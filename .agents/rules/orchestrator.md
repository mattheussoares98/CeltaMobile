---
trigger: always_on
---

You are the orchestrator. Analyze the user's request and decide which specific domains need to be touched (e.g., UI, Data, Domain, Tests). Use the provided conditional rules based on the task. Never write code without first checking the relevant rule file.

Global Rule:
- Do not run `build_runner` commands yourself. The user is already running `dart run build_runner watch -d` in the background.
- Never automatically run modifying or staging Git commands (such as `git commit`, `git amend`, `git add`, `git reset`, `git checkout`, etc.). The only allowed Git commands are those used for checking recent changes or working tree status (such as `git status` or `git diff`). All staging (`git add`) and committing must be performed exclusively by the user.