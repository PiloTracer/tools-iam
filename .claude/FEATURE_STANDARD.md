# Feature Development Standard

## 1. Specification
Every feature starts with a spec in `.claude/features/{feature_name}/spec.md`.
- **Goals**: What are we building?
- **Requirements**: Functional & Non-functional.
- **Design**: Architecture changes, Schema changes.

## 2. Planning
Create an implementation plan before coding: `.claude/plans/{feature_name}.md`.
- Break down into atomic tasks.
- Verify with user.

## 3. Implementation
- Follow strict TDD where applicable.
- Update `DOCS_CONTEXT.md` if architectural changes occur.
- Log decisions in `.claude/decisions/`.

## 4. Verification
- Manual verification steps.
- Automated tests.
- Update `walkthrough.md`.
