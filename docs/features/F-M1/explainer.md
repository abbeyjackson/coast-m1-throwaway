# F-M1: Greeter — how this works

**What it does:** This feature adds a simple "greeter" to the app. Give it a
name and it says hello to that person. Don't give it a name and it falls
back to a friendly default greeting.

**In plain terms:**
- Ask it to greet "Ava" → it replies "Hello, Ava!"
- Ask it to greet with no name at all → it replies "Hello, world!"
- Ask it to greet an empty name → it still replies politely, "Hello, !"

**Why it's built this way:** This is the first, smallest possible building
block (an "M1") used to prove the whole pipeline — from idea, to test, to
working code — runs end to end. There's no UI or network call involved yet;
it's a single, well-tested piece of logic that other features can build on
later.

**How we know it works:** Three automated checks (tests) confirm the exact
wording of each greeting scenario above. If any of that behavior ever
changes unexpectedly, those checks will fail and flag it before it reaches
real users.
