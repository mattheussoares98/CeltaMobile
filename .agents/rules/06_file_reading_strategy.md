---
trigger: always_on
---

Always check file size before reading. Strategy by size:

| File Size  | Action |
|------------|--------|
| < 15kb     | Full read allowed |
| 15–60kb    | `grep_search` keyword → read ~100 lines around match |
| > 60kb     | `grep_search` only → max 100 lines per chunk |
| Generated (`.g.dart`, `.freezed.dart`) | Never read in full — grep for specific symbols only |

**Expanding context**: if more is needed, extend by +50 lines at a time. Never re-read already-seen lines. Never read a whole large file in one go.

**Good grep keywords**: class names, method signatures, field names, `@riverpod`. Avoid generic terms like `import`, `class`, or `final` alone.
