---
trigger: always_on
---

## Why This Rule Exists

Reading large files in full wastes context window tokens and slows responses.
Most tasks only require a specific region of a file. This rule enforces targeted,
efficient reading without sacrificing answer quality.

---

## Step 0 — Always Check File Size First

Before reading any file, determine its size. The `view_file` tool reports
`Total Bytes` on the first read. Use this to decide your strategy.

---

## Reading Strategy by File Size

### < 15kb → Read Normally
No restrictions. Read the file in full if needed.

### 15kb – 60kb → Targeted Read
1. Use `grep_search` with a relevant keyword (class name, method name, field name)
   to identify the exact line range of interest.
2. Read only that region, using approximately **100 lines** as the window.
3. If more context is needed, **extend downward by +50 lines** per step.
4. Never re-read lines you have already seen.

### > 60kb → Grep Only — Never Full Read
1. Use `grep_search` exclusively to locate the target region.
2. Read a maximum of **100 lines** around the match.
3. If additional context is required, extend by **+50 lines** at a time.
4. If the file is generated (e.g., `.g.dart`, `.freezed.dart`), avoid reading
   it entirely — rely on the source file and grep for specific symbols only.

---

## Escape Clause — When You Need More Context

If after reading the targeted section you still lack sufficient confidence
to answer correctly (e.g., for broad architectural questions or tracing a
full data flow), you may progressively expand the reading window:

1. Extend by +50 lines in the direction most likely to contain the missing context.
2. Use `grep_search` to find related symbols in *other* files rather than
   reading more of the current large file.
3. Only as a last resort, read the next 100-line chunk.

**Never skip this rule to read an entire large file in one go.**

---

## Practical Keyword Selection for `grep_search`

When choosing keywords, prefer:
- **Class names:** `class MyRepository`, `class MyController`
- **Method names:** `Future<X> methodName`, `void methodName`
- **Field names:** `final String fieldName`
- **Riverpod providers:** `@riverpod`, `myFeatureProvider`

Avoid generic terms like `import`, `final`, or `class` alone — they will
return too many results and defeat the purpose.

---

## Summary Table

| File Size   | Action                                              |
|-------------|-----------------------------------------------------|
| < 15kb      | Full read allowed                                   |
| 15 – 60kb   | `grep_search` → read ~100 lines around match        |
| > 60kb      | `grep_search` only → read max 100 lines per chunk   |
| Generated   | Never read in full regardless of size               |
