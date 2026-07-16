# F-M1: Greeter — How This Works

## What it does

This feature adds a simple "greeter" to the app. Think of it like a
tiny digital doorman: you can hand it a name, and it politely says
hello back to that person. If you don't give it a name, it just says
hello to the world in general.

## In plain terms

- Give it a name, like `"Alice"`, and it replies: **"Hello, Alice!"**
- Give it nothing at all, and it replies: **"Hello, world!"**
- Give it an empty name (just blank text), and it still replies
  politely: **"Hello, !"** — it doesn't crash or get confused, it just
  greets whatever it's given.

## Why it matters

This is the very first building block (milestone 1) of the app. It's
intentionally small and simple — its job is to prove that the basic
plumbing of the app (writing code, testing it, and confirming it
works) is solid before we build anything more complex on top of it.

## How we know it works

We wrote automated checks (tests) that ask the greeter to greet a
name, greet with no name, and greet with an empty name — and confirm
it responds exactly as expected every time. These tests run
automatically whenever the code changes, so if anything ever breaks
this behavior, we'll know immediately.
