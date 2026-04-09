---
description: Draft and create a PR with an AI-generated description (usage: /pr-create [branch])
agent: plan
---

I want to create a pull request against `$ARGUMENTS` (default to `master` if not specified).

Analyze my changes and draft a PR title and a short **Summary** describing what was changed and why.

**Commits on this branch:**
!`BRANCH="$ARGUMENTS"; git log $(git merge-base ${BRANCH:-master} HEAD)..HEAD --oneline`

**Diff of committed changes:**
!`BRANCH="$ARGUMENTS"; git diff $(git merge-base ${BRANCH:-master} HEAD)..HEAD`

Present the draft title and summary. Wait for my feedback and iterate until I confirm. Once I approve, use the GitHub MCP tool to create the PR with the agreed-upon title and description.
