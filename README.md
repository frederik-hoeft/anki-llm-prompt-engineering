# Anki LLM Prompt Engineering

A semi-automated workflow for generating Anki flashcards from lecture PDFs using Large Language Models.

## Purpose

This repository provides a structured, two-phase prompting strategy to create exam preparation flashcards:

1. **Phase 1**: Generate a validated slide index from lecture PDF(s)
2. **Phase 2**: Create Anki cards in CSV format with strict coverage rules

The workflow ensures comprehensive coverage by requiring the LLM to account for every slide, preventing accidental omissions that could occur with single-pass generation.

## Directory Layout

- universal/ — Provider-agnostic, two-phase workflow (prompts: prompt-1.md, prompt-2.md; runner: ankify.sh)
- openai/ — OpenAI-only, one-shot workflow (prompts: prompt-openai-1.md, prompt-openai-2.md; runner: ankify-openai.sh). It tends to be more deterministic but may occasionally stop; if that happens, send the manual prompt: "Load previous checkpoint and continue".

## Prerequisites

- Standard GNU Linux/MinGW tooling (bash, realpath, dirname, cat, tee)
- [dotnet-scripts](https://github.com/frederik-hoeft/dotnet-scripts) utilities:
  - `esed` - sed with fully featured .NET regex support
  - `eclip` - Clipboard management
  - `normalize` - Unicode $\to$ ASCII normalization
- Access to an LLM (e.g., ChatGPT, Claude) with file upload capability

## Usage

### Universal workflow (LLM-agnostic)

```bash
./universal/ankify.sh <lecture-name>
```

1. **Run the script** with your lecture identifier:
   ```bash
   ./universal/ankify.sh lecture-02
   ```

2. **Phase 1 - Slide Index**:
   - The script copies the Phase 1 prompt to your clipboard
   - Paste into your LLM along with the lecture PDF(s)
   - The LLM generates a numbered slide index and validates slide count
   - Press Enter in the terminal to continue

3. **Phase 2 - Card Generation**:
   - The script copies the Phase 2 prompt to your clipboard
   - Paste into the LLM (same conversation)
   - The LLM generates Anki cards in CSV format
   - Copy the CSV output to clipboard
   - Press Enter in the terminal

4. **Output**:
   - `<lecture-name>.csv` - Importable Anki deck
   - `<lecture-name>.md` - Human-readable Markdown for review

### OpenAI-only workflow (more deterministic)

```bash
./openai/ankify-openai.sh <lecture-name>
```

- Phase 1 prompt ([openai/prompt-openai-1.txt](openai/prompt-openai-1.txt)): Paste into ChatGPT with the lecture PDF; it does slide-by-slide generation with checkpoints. When it emits the CSV, copy that to the clipboard before continuing.
- Phase 2 prompt ([openai/prompt-openai-2.txt](openai/prompt-openai-2.txt)): The script copies this for you after Phase 1. Paste it (same chat) to clean up and compress the cards, then copy the final CSV to the clipboard.
- The script saves both the raw and cleaned CSV/MD outputs automatically.
- Expected occasional stall: ChatGPT may return `BLOCKED` with `REASON=tool_auth_failure` and an internal HTTP 401 trace when opening a rendered slide. When that happens, simply send `Load previous checkpoint and continue` in the same chat; it should resume from the last checkpoint. Continue doing this until it finishes all slides.

### Processing Pipeline

The script automatically processes LLM output through:
- Unicode normalization (removes emojis and non-ASCII quotes)
- Arrow substitution (`->` to `\(\to\)` for LaTeX)
- CSV-to-Markdown conversion for review

## Card Quality Rules

- Titles are NOT questions; they identify topics without revealing answers
- Preferred format: "Topic: specific focus"
- Backsides are concise, with comma-separated facts
- Enumerable facts include count: `"Memory segments (5)","1. text, 2. data, ..."`
- Math uses `\(...\)` for MathJax compatibility
- Meta content (slide numbers, chapter summaries) is skipped

## License

See repository license file for details.