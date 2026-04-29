---
trigger: model_decision
description: Rules for folder structure and overall app architecture
---

- Every folder should have a `.dart` file with the same name, exporting all files and folders from that path.
- Every import should reference the exporter file (the file with the same name as the folder that exports all files from it).
- If you are not sure how to create a file, look at the `sale_request` feature and build it similarly.
- Check every import for problems. If an import is broken, find the correct relative path and fix it.

Navigation
- When creating a new feature, you should add the route as well, following the pattern of other routes.