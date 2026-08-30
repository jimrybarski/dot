---
name: purify
description: Refactors code to separate pure from impure functionality. Use whenever the user asks you to "purify" a codebase.
---

# Definition of pure and impure functions

A pure function is one that is guaranteed to behave in exactly the same way when invoked with the same inputs (ignoring out-of-memory errors or other faults). For example, this function:

```python
def add(a: int, b: int) -> int:
    return a + b
```

will always return `8` when we call `add(3, 5)`.

An impure function can behave differently depending on the state of the program and/or machine:

```python
def add(filename: str) -> int:
    with open(filename) as f:
        a = int(f.readline())
        b = int(f.readline())
    return a + b
```
            
This function will throw a `FileNotFoundError` if `filename` is not a valid path, for example, but will succeed if it is. If the file contains only one line, or each line can't be parsed as an integer, other errors will occur. It isn't possible to determine whether this function will return a number until runtime.

# Separating pure from impure functionality

Some impure code is almost always required for a useful computer program, however, it makes testing difficult. Impure code is often trivial and simply exercises well-tested standard library functions.

## Example

Let's take our bad function from above. The requirements for this project state that we must read a file and add the first two lines, but testing whether we're doing the math correctly requires files on disk.

```python
# Simple pure function
def parse_numbers(a: str, b: str) -> Tuple[int, int]:
    a = int(a)
    b = int(b)
    return a, b

# Simple pure function
def add_numbers(a: int, b: int) -> int:
    return a + b

# This function isn't pure, but factoring it out makes the add() function more readable.
def read_lines(filename):
    a = f.readline()
    b = f.readline()
    return a, b
    
# There's usually one function that orchestrates everything, where impure inputs are received and passed to pure functions and vice versa.
def add(filename: str) -> int:
    with open(filename) as f:
        a, b = read_lines(filename)
        a, b = parse_numbers(a, b)
        return add_numbers(a, b)
```

The above example doesn't document or handle the exceptions, but the goal here is just to demonstrate identifying and factoring out the pure parts of a program. `parse_numbers` and `add_numbers` can be tested without restrictions on any machine, and testing them should be essentially instantaneous as no database connections or file accesses need to be performed.
