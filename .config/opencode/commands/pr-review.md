---
description: Review git changes before creating a PR (usage: /pr-review [branch])
---

Please do a thorough pre-PR code review of my current changes against `$ARGUMENTS` (defaulting to `master` if no branch was specified).

---

**Uncommitted changes (staged and unstaged):**
!`git diff HEAD`

---

**Commits on this branch:**
!`BRANCH="$ARGUMENTS"; git log $(git merge-base ${BRANCH:-master} HEAD)..HEAD --oneline`

**Diff of committed changes:**
!`BRANCH="$ARGUMENTS"; git diff $(git merge-base ${BRANCH:-master} HEAD)..HEAD`

---

Please provide a thorough review covering:

- Potential bugs or logic errors
- Code quality and readability
- Naming clarity
- Missing tests or edge cases
- Anything that should be addressed before opening a PR
