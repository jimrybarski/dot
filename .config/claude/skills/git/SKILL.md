---
name: git
description: Git best practices. Use when committing, branching, or resolving conflicts. Use when making a release, choosing a semantic version bump, tagging, or writing a changelog. Use to understand the history of the codebase.
---

# When to use

Always, when working in (or creating) version-controlled codebases.

# Core Principles

- Keep `main` always deployable. 
- Work on the `main` branch for small changes, and use feature branches whenever the change will be large, complex, or risky.
- Each successful, semantically-coherent change gets its own commit. Don't accumulate large uncommitted changes.

# Atomic commits

Each commit does one logical thing:

```
# Good: Each commit is self-contained
git log --oneline
a1b2c3d Add task creation endpoint with validation
d4e5f6g Add task creation form component
h7i8j9k Connect form to API and add loading state
m1n2o3p Add task creation tests (unit + integration)

# Bad: Everything mixed together
git log --oneline
x1y2z3a Add task feature, fix sidebar, update deps, refactor utils
```

# Descriptive messages

Commit messages explain the *why*, not just the *what*, and document critical assumptions or other information that will
affect future planned development. Future agents will need context that doesn't always belong in code comments or other
documents.

```
# Good: Explains intent
feature: add email validation to registration endpoint

Prevents invalid email formats from reaching the database.
Uses Zod schema validation at the route handler level,
consistent with existing validation patterns in auth.ts.

Multiple instances are not currently supported as we rely
on exclusive access to the cache file (see cache.rs where
this is hard-coded).

# Bad: Describes what's obvious from the diff
update auth.ts
```

**Format:**
```
<type>: <short description>

<optional body explaining why, not what>
```

**Types:**
- `feature` — New feature
- `fix` — Bug fix
- `refactor` — Code change that neither fixes a bug nor adds a feature
- `test` — Adding or updating tests
- `docs` — Documentation only
- `chore` — Tooling, dependencies, config

# Authorship

Set the current user as the sole author of all commits.

# Keep concerns separate

Don't combine formatting changes with behavior changes. Don't combine refactors with features. Each type of change should be a separate commit:

```
# Good: Separate concerns
git commit -m "refactor: extract validation logic to shared utility"
git commit -m "feature: add phone number validation to registration"

# Bad: Mixed concerns
git commit -m "refactor validation and add phone number field"
```

**Separate refactoring from feature work.** A refactoring change and a feature change are two different changes — submit them separately. This makes each change easier to review, revert, and understand in history. Small cleanups (renaming a variable) can be included in a feature commit at reviewer discretion.

# Resolve uncommitted changes before beginning new work

If there are uncommitted files when you begin working on a task, stop and ask the user if they'd like to commit those 
first before beginning. This shouldn't happen, and when it does, it implies a process error of some kind.

# Branch Naming

```
feature/<short-description>   → feature/task-creation
fix/<short-description>       → fix/duplicate-tasks
chore/<short-description>     → chore/update-deps
refactor/<short-description>  → refactor/auth-module
```

# Handling Generated Files

- **Commit generated files** only if the project expects them (e.g., `Cargo.lock`)
- **Don't commit** build output (`dist/`, `.next/`), environment files (`.env`), or IDE config (`.vscode/settings.json` unless shared)
- **Have a `.gitignore`** appropriate to the language. Github's gitignore repo is cloned in $HOME/.local/gitignore-templates.

### Keep a changelog written for humans

A changelog is not `git log`. It's the curated, consumer-facing answer to "what changed and do I care?" — grouped by `Added / Changed / Fixed / Deprecated / Removed / Security`, newest on top, every entry phrased around user impact, not internal mechanics.

```markdown
## [1.4.0] - 2025-06-12
### Added
- Bulk task import via CSV
### Fixed
- Timezone drift in recurring task due dates
### Deprecated
- `GET /v1/tasks/all` — use the paginated `GET /v1/tasks` (removal in 2.0)
```

Write the entry in the same change that makes the change.

# Checklist

For every commit:

- [ ] Commit does one logical thing
- [ ] Message explains the why, follows type conventions
- [ ] Tests pass before committing
- [ ] No secrets in the diff
- [ ] No formatting-only changes mixed with behavior changes
- [ ] `.gitignore` covers standard exclusions
