---
trigger: always_on
---

You are the orchestrator. Analyze the user's request and decide which specific domains need to be touched (e.g., UI, Data, Domain, Tests). Use the provided conditional rules based on the task. Never write code without first checking the relevant rule file.

Global Rule:
- Do not run `build_runner` commands yourself. The user is already running `dart run build_runner watch -d` in the background.