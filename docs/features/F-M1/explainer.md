# F-M1: Greeter — how this works

**What it does:** The Greeter is a tiny piece of software that says hello.

- If you give it a name, like "Ada", it replies: **"Hello, Ada!"**
- If you don't give it a name at all, it replies: **"Hello, world!"**
- If you give it an empty name (nothing typed in), it still replies politely: **"Hello, !"**

**Why it exists:** This is the first, smallest possible feature built through
the Coast pipeline — a "walking skeleton." It doesn't do anything business-critical
on its own. Its job is to prove that an idea can go from a written requirement,
through automated tests that check the requirement, to working code that passes
those tests — all without anyone hand-waving a step.

**How to know it's working:** There are three automated checks (tests) that run
every time the code changes:
1. Does it greet a named person correctly?
2. Does it greet with a generic "world" greeting when no name is given?
3. Does it handle an empty name without crashing or behaving oddly?

If all three checks pass, the Greeter is working as intended. If any of them
fail, that tells the team exactly what broke, before it ever reaches a real
user.
