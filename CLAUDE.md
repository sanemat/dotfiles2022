# Project Rules (Global)

## Language
- Use **B1-level English**
- Be **short, clear, and accurate**
- Avoid unnecessary words

## Git Workflow
- Fetch before creating a branch
```
git fetch origin
git checkout -b <branch-name> origin/main
```

- Always use full command when pushing
```
git push origin <branch-name>
```
- Do not use short forms like `git push` alone

- Check diff against origin/main before pushing
```
git diff origin/main...HEAD
```

## Commits
- Use **Conventional Commits (Angular style)**  
Examples:
- `feat: add user login`
- `fix: handle null response`
- `docs: update README`

- Make commits in **meaningful units**
- One commit = one clear purpose

## General
- Do not mix unrelated changes
- Prefer simple and explicit solutions
