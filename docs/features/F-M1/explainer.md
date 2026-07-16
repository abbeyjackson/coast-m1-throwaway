# How greeting works

The app can greet people. Given a name, it says "Hello, <name>!"; with no
name it says "Hello, world!". One small service (`Greeter`) owns this, so
any screen that needs a greeting asks it — there is exactly one place the
wording lives.
