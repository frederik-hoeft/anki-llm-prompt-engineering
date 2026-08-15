Use the **exam-material-extraction** skill to generate high-quality, exam-focused Anki cards from the lecture material:

**Target lecture:** `{LECTURE}`

Resolve `{LECTURE}` against the supplied/available lecture files and use the matching PDF as the source.

Follow the skill's complete workflow and quality contract, including exhaustive visual inspection of every physical PDF page, strict source grounding, deterministic page coverage, resumable checkpointing, duplicate control, and fail-closed handling when reliable inspection is impossible.

Use the skill's default Anki output schema and card-design rules unless explicitly overridden by additional instructions in this prompt.

On successful completion, output the complete CSV followed by the final page-coverage summary. If completion is blocked, return the skill's blocking/resume report instead.
