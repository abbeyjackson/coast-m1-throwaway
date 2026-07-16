#!/usr/bin/env python3
"""Coast review agent — a literal GitHub PR reviewer (D26), running in the
isolated CI runner (D47) with the customer's model key from Actions secrets.

CI-side agent shape per the tool-authority matrix §8: it reads the PR
checkout and diff, judges the work against the approved plan, and submits a
real PR review — the reviewer decides blocking vs non-blocking. It cannot
push (workflow token: contents read, pull-requests write); the pusher
credential never enters CI.

Reviewers use the thin model client (D44/D90): a direct Messages API call,
structured output validated field-by-field with bounded retries (D37/D72).
Everything a finding cites is mechanically verified against the diff (D39).

Usage: review_agent.py <pr_number> <base_sha> <head_sha>
Env: ANTHROPIC_API_KEY (Actions secret), GH_TOKEN, GITHUB_REPOSITORY.
"""

import json
import os
import subprocess
import sys
import urllib.request

MODEL = "claude-sonnet-5"
RETRY_FIELD = 3  # D72
MAX_DIFF_CHARS = 60_000


def sh(*args, stdin=None):
    result = subprocess.run(args, capture_output=True, text=True, input=stdin)
    if result.returncode != 0:
        raise RuntimeError(f"{' '.join(args[:3])}… failed: {result.stderr.strip()}")
    return result.stdout


def call_model(system, messages):
    request = urllib.request.Request(
        "https://api.anthropic.com/v1/messages",
        data=json.dumps({
            "model": MODEL,
            "max_tokens": 4096,
            "system": system,
            "messages": messages,
        }).encode("utf-8"),
        headers={
            "content-type": "application/json",
            "x-api-key": os.environ["ANTHROPIC_API_KEY"],
            "anthropic-version": "2023-06-01",
        })
    with urllib.request.urlopen(request, timeout=300) as response:
        payload = json.load(response)
    return "".join(block.get("text", "") for block in payload.get("content", []))


SYSTEM = """You are Coast's review agent: a literal GitHub pull-request reviewer for an
orchestrated build system. The deterministic facts are settled before you read anything:
the proof file verified, every diff path inside the declared scope, deletions matched to
approved removals, build and tests green. Do NOT re-derive those. Your judgment residue:

- Does the implementation honor the approved plan items' semantics (right kind of thing,
  right place, faithful to each item's description)?
- Do the tests genuinely lock the acceptance criteria (real assertions, not
  false-passing)?
- Is the below-plan-resolution elaboration sound (no smuggled scope, no speculative
  abstraction, honest naming)?

You decide blocking vs non-blocking, exactly like a human reviewer. Reply with ONLY a
JSON object, no markdown fence, of the shape:
{"verdict": "approve" | "request_changes" | "comment",
 "summary": "<one paragraph>",
 "findings": [{"file": "<path from the diff>", "rule": "<what principle>",
               "finding": "<specific, actionable>", "blocking": true|false}]}
Rules: verdict "request_changes" requires at least one blocking finding; every finding's
"file" must be a path that appears in the diff; a clean approval still lists what you
checked in "summary" (a bare approval is invalid)."""


def main():
    pr_number, base_sha, head_sha = sys.argv[1], sys.argv[2], sys.argv[3]
    repo = os.environ["GITHUB_REPOSITORY"]

    feature_id = os.environ.get("GITHUB_HEAD_REF", "").removeprefix("feature/")
    plan = open(f"plans/{feature_id}/plan.json").read()
    diff = sh("git", "diff", f"{base_sha}..{head_sha}")
    if len(diff) > MAX_DIFF_CHARS:
        diff = diff[:MAX_DIFF_CHARS] + "\n… [diff truncated]"
    diff_paths = set(sh("git", "diff", "--name-only", f"{base_sha}..{head_sha}").split())

    prompt = (f"The approved plan (already merged via its own reviewed PR):\n{plan}\n\n"
              f"The implementation diff to review:\n{diff}")

    messages = [{"role": "user", "content": prompt}]
    review = None
    for attempt in range(1, RETRY_FIELD + 1):
        text = call_model(SYSTEM, messages).strip()
        errors = []
        try:
            candidate = json.loads(text)
        except ValueError as err:
            errors.append(f"not valid JSON: {err}")
            candidate = None
        if candidate is not None:
            if candidate.get("verdict") not in ("approve", "request_changes", "comment"):
                errors.append("verdict: must be approve | request_changes | comment")
            if not candidate.get("summary"):
                errors.append("summary: required, non-empty (a bare verdict is invalid)")
            findings = candidate.get("findings", [])
            for index, finding in enumerate(findings):
                if finding.get("file") not in diff_paths:
                    errors.append(f"findings[{index}].file: '{finding.get('file')}' is not in the diff "
                                  "(everything cited must exist — mechanical check)")
                if not finding.get("finding"):
                    errors.append(f"findings[{index}].finding: required")
            if candidate.get("verdict") == "request_changes" and not any(f.get("blocking") for f in findings):
                errors.append("verdict request_changes requires at least one blocking finding")
        if not errors:
            review = candidate
            break
        # Surgical field rejection (D37): only the listed fields, bounded retries.
        messages += [{"role": "assistant", "content": text},
                     {"role": "user", "content": "RETRY_FIELD — invalid fields: " + " | ".join(errors)
                      + ". Resubmit the full JSON with ONLY these corrected."}]
        print(f"field rejection round {attempt}: {errors}")

    if review is None:
        print("review agent failed structured output after retries — failing the job (blocked, never silent)")
        return 1

    event = {"approve": "APPROVE", "request_changes": "REQUEST_CHANGES", "comment": "COMMENT"}[review["verdict"]]
    lines = [f"**Coast review agent** ({MODEL})", "", review["summary"], ""]
    for finding in review.get("findings", []):
        marker = "🛑 blocking" if finding.get("blocking") else "💬 non-blocking"
        lines.append(f"- {marker} — `{finding['file']}` — {finding.get('rule', '')}: {finding['finding']}")
    body = "\n".join(lines)

    sh("gh", "api", "-X", "POST", f"/repos/{repo}/pulls/{pr_number}/reviews",
       "-f", f"event={event}", "-f", f"body={body}")
    print(f"review submitted: {event}")
    # A blocking review leaves the PR unmergeable via the ruleset — the fix
    # loop (L4) is Coast's to drive; the job itself succeeded.
    return 0


if __name__ == "__main__":
    sys.exit(main())
