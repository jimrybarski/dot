---
name: test
description: Write tests following Jim's standards. Uses pytest for Python and cargo's built-in framework for Rust. Invoke with /test to generate tests for the current code.
---

# Testing Standards

When writing tests, follow these conventions by language. Ask the user which file or function to test if not specified.

## General Rules

- Write unit tests for all pure functions and methods.
- Write property-based tests for important or complex algorithms.
  - If the language allows, mark property-based tests as slow, and only run them if the unit tests pass. This is a speed optimization.
- Write integration tests for:
  1. Functionality that reads/writes to the local disk or to/from stdin/stdout
  2. Functionality that goes ONLY over the local network to a server we're running ourselves. Such servers are either a complementary project we're working on, or a transient one you write in Python to mock responses.
- For projects that mostly perform calculations or are scientific in nature, use mutation testing.
  - When mutation testing, if there are any mutants, you must kill them by changing the application code, not by weakening or deleting tests (unless the tests are broken). You should, of course, write more tests for any new functionality you write when doing all of this.
- If there's pure, non-trivial logic in an impure function, propose factoring that part out to its own function.
- Write integration tests after unit tests are complete and all passing. These are the only tests that call impure functions.
- Do not write tests for functions that do anything over the network unless we can run the actual server ourselves.
- Test names should describe the scenario, not the implementation.
- Each test should be documented with a clear explanation of the scenario and assumptions of the test.
- Use parameterized tests when reasonable to reduce noise. Document the scenario of each set of parameters inline.
- Do not use mock objects.

## Python — pytest, hypothesis and mutmut

- Test file location: alongside source in `tests/`, mirroring src layout
- Naming: `test_<module>.py`, functions as `test_<behavior>()`
- Fixtures: prefer fixtures over setup
- Markers: `@pytest.mark.slow` for property-based tests or other slow tests, `@pytest.mark.integration` for integration tests.
  - These do not run by default and must be opted into.

## Rust — cargo test

- Unit tests go in a `#[cfg(test)]` module at the bottom of the source file.
- Integration tests go in `tests/`.
- Doc tests: for every public API/function

## Bash / fish

- Check scripts with shellcheck. All lints must pass before a script is considered complete.
- It's okay to put a pragma to skip a check within reason, but ask the user.
- I would prefer unchecked simple code over obfuscating just to satisfy shellcheck.
