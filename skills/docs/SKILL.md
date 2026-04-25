---
name: docs
description: Jim's code documentation standards across Python, Rust, Bash, fish, and Swift. Claude-only reference — apply these standards when writing or reviewing code.
user-invocable: false
---

# Documentation Standards

Apply these standards when writing or reviewing code. The guiding principle: document the **why**, not the **what**. Well-named identifiers explain what code does; comments explain hidden constraints, non-obvious invariants, or surprising behavior.

## General Rules

- Default to writing no comments.
- Only add an inline comment when the WHY is non-obvious: a hidden constraint, a subtle invariant, a workaround for a specific bug, behavior that would surprise a reader.
- Never write comments that restate what the code already says.
- No multi-paragraph comment blocks.
- For complex algorithms, explain not just what each step does, but explain how it fits into the big picture. These comments should be written as if to teach the reader how the algorithm works.
- Write comments for every function, class, struct, enum, constant, and heterogeneous datastructure, both public and private. 

## Python

- Docstring format: Google
- When to write a docstring: all functions and classes.
- Type annotations: required. Complex types should be given aliases.
- Module-level docstrings: Always, but just 1-2 sentences.

## Rust

- Use `///` doc comments for public items in library crates.
- When to document private items: always
- Include `# Examples` sections: public items only
- `# Panics` and `# Errors` sections: only when possible.
- Module-level docs (`//! ...`): Always, but just 1-2 sentences.
- Write docs that satisfy both `#![deny(missing_docs)]` and `#![deny(clippy::missing_docs_in_private_items)]`.
- Write doctests for public functions only.

## Bash

- Add a 1-2 sentence description of the script's purpose two lines after the shebang, with one blank line separating them.
- Give a general summary of each block of functionality, so that someone who wrote the script months or years ago can quickly go through it and get back up to speed.
- Document individual lines if there's non-obvious logic.

## fish shell

- Document each function with a one-sentence summary, and explain the type and purpose of each input and output.
- For things related to shell configuration, explain what each setting does.

## Swift

- Use `///` doc comments for public API.
- Use DocC style.
