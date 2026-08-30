---
name: documentation
description: Requirements for creating documentation for computer programs, scripts and configuration files. Use every time when writing code comments or supporting documentation, or when the user asks you to "document" a codebase.
---

# Brevity is key

We follow the spirit of the quote "If I had more time, I would have written a shorter letter." Be concise, but never sacrifice critical information. Each word should be deliberate and meticulously chosen.

# Code comments

## Audience

Write comments aimed at getting a future contributor up to speed. Assume the contributor has read the README and knows the overall purpose of the software, but has no familiarity at all with the implementation.

Document both the *what* and the *why*, and put things in context. The bigger the project, the more context is appropriate.

### Example class

BAD comment: what are these tokens, and whey are we referencing them? What is the cache for? What are slots? What types do the slots support? What is an InferenceManager?

```
# Stores references for each token in an LRU cache. Each slot can support instances of any type as long as the InferenceManager is in scope.
class NetworkSupport:
   ...
```

GOOD comment: explains things briefly, explains how this fits into the bigger picture, and gives enough context that the jargon makes sense when explained.

```
# Users submit authentication tokens via an API call, which are then cached here (which reduces response times by roughly 30%). We use an LRU cache as we prioritize the user that has been waiting the longest.
This maps directly to our hardware device that has 8 physical slots capable of processing requests. If the InferenceManager is in scope, we can place both Dog requests and Cat requests, as the InferenceManager can tell the hardware which type to request. Otherwise, they must be manually specified by the user.
class NetworkSupport:
   ...
```

### Example function

BAD comment: why do we need to compute this? What even is cosine similarity?

```
# Computes cosine similarity.
def cosine_similarity(a: Vec[float], b: Vec[float]):
    ...
```

GOOD comment:

```
# Computes the cosine similarity between two word vectors (i.e. machine representations of ideas). The cosine similarity of such vectors tells us how semantically similar they are, e.g. "cat" will be much more similar to "dog" than "submarine". -1 is an exact opposite, 0 is completely unrelated, and 1 is identical.
def cosine_similarity(a: Vec[float], b: Vec[float]):
    ...
```

# Add type hints when supported

Languages like Python must always have type hints.

# Create aliases for complex types

If type signatures get gnarly, condense them into aliases. We consider type hints to be machine-readable forms of documentation.

```
# BAD
def interpolate(a: Dict[Tuple[int, str], List[bool]]):
   ...

# GOOD
type TrialSuccessRecord = Dict[Tuple[int, str], List[bool]]

def interpolate(a: TrialSuccessRecord):
   ...
```

# Algorithms need to be taught to the user

Use a didactic tone and approach when commenting each step in an algorithm. Explain whether steps are performance optimizations or are necessary for correctness. Explain what each semantic chunk does (and why it works, if not obvious):

```python
# Returns true when a given number has no divisors other than 1 and itself. We use this to determine if a multi-year interval could potentially be related to a cicada brood emergence cycle. Cicada broods emerge only in prime number years to minimize competition with other broods of different cycle lengths.
def is_prime(n):
    # Numbers less than 2 (0, 1, negatives) are not prime by definition
    if n < 2:
        return False

    # 2 is the only even prime number, so handle it explicitly
    if n == 2:
        return True

    # Eliminate all other even numbers early as an easy performance optimization.
    if n % 2 == 0:
        return False

    # Only need to check odd divisors up to the square root of n,
    # since a larger factor would have a corresponding smaller one already checked
    i = 3
    while i * i <= n:
        # If n is divisible by i, it's not prime
        if n % i == 0:
            return False
        # Skip even numbers by incrementing by 2 (only check odd candidates)
        i += 2

    # If no divisors were found, n is prime
    return True
```

# Enums

This can be difficult as sometimes a good name makes a comment redundant. However, in Rust we will usually add a
directive that prevents compilation if anything is left undocumented, so it can be necessary.

Try to add even a sliver of value if a meaningful comment isn't possible. Here, the user probably knows what these common abbreviations stand for, but spelling it out helps in the rare case that they don't. Worst case scenario, just restate the variant name.

```rust
// Which color encoding to use
enum Palette {
    // Red, green, blue
    RGB,
    // Cyan, magenta, yellow, blacK
    CMYK,
    // Black and white
    BlackAndWhite
}
```

# Python documentation

Use the python-docs skill for the formatting of Python documentation.
