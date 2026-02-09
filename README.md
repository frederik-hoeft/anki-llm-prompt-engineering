# Anki LLM Prompt Engineering

A semi-automated workflow for generating Anki flashcards from lecture PDFs using Large Language Models.

## Purpose

This repository provides a structured, two-phase prompting strategy to create exam preparation flashcards:

1. **Phase 1**: Generate a validated slide index from lecture PDF(s)
2. **Phase 2**: Create Anki cards in CSV format with strict coverage rules

The workflow ensures comprehensive coverage by requiring the LLM to account for every slide, preventing accidental omissions that could occur with single-pass generation.

## Prerequisites

- Standard GNU Linux/MinGW tooling (bash, realpath, dirname, cat, tee)
- [dotnet-scripts](https://github.com/frederik-hoeft/dotnet-scripts) utilities:
  - `esed` - sed with fully featured .NET regex support
  - `eclip` - Clipboard management
  - `normalize` - Unicode $\to$ ASCII normalization
- Access to an LLM (e.g., ChatGPT, Claude) with file upload capability

## Usage

```bash
./ankify.sh <lecture-name>
```

### Workflow

1. **Run the script** with your lecture identifier:
   ```bash
   ./ankify.sh lecture-02
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