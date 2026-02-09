Phase 2: Create Anki cards from the validated slide index of your previous response and the {LECTURE} PDF content. 

Sources:
- The validated slide index from Phase 1.
- {LECTURE} PDF(s) are available in the workspace.

Output format:
- CSV, one card per row: "Title","Backside"
- Quote every field with double quotes.
- Return ONLY the final CSV in a single markdown code block.
- Language: English.
- Math uses \(...\). MathJax formatting is supported.

Card rules:
- Titles are NOT questions.
- Titles must not reveal the answer.
- Prefer: "Topic: specific focus"
- Backside is concise; comma-separated facts allowed.
- When asking for multiple, enumerable, comma-separated facts, add "(N)" at the end of the title, where N is the number of facts (e.g., `"Memory layout: segments (5)","1. text, 2. data, 3. bss, ..."`).
- Skip meta content (slide numbers, "this slide shows...", "this lecture covers...", "chapter summary", etc.).

Coverage rules (strict):
- For EVERY slide index entry, do one of:
  A) generate >=1 card, OR
  B) explicitly decide "skip as not exam-relevant".
- However, decisions for (B) must NOT be printed verbatim in the final output.
- Internally ensure no slide is accidentally ignored.

Hard requirement to prevent misses:
Before outputting the final CSV, internally verify that each slide was visited.
If you cannot access slide content reliably, STOP and say exactly:
"BLOCKED: cannot read PDF content reliably"
(with no CSV).

Stop condition:
Output ONLY the CSV code block (or the BLOCKED line).