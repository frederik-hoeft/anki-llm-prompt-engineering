# Anki LLM Prompt Engineering

A semi-automated, skill-based ChatGPT workflow for producing source-grounded, exam-focused Anki cards from lecture PDFs and supporting course material.

At the start of a course, the workspace-bootstrap skill inventories the complete project, establishes source authority, and produces a retrieval index and exam-focus reference. The per-lecture workflow then has two stages:

1. **Extraction** visually inspects every physical PDF page and builds a comprehensive, checkpointed card set.
2. **Optimization** refines that card set using assignments, solutions, sample exams, and other authoritative course material as evidence of exam relevance.

The result is still a draft for human review. The intended steady state is to merge the raw cards, optimized cards, and your own understanding before import. See the [complete self-study workflow](workflows/chatgpt-selfstudy-workflow.md).

## Prerequisites

- ChatGPT with project file context and support for the supplied skills
- Anki
- Lecture slides as PDFs
- Supporting course material for useful optimization, such as assignments, solutions, sample exams, instructor notes, tutorials, labs, or focus documents

## One-Time Course Setup

1. Create a ChatGPT project for the course.
2. Upload the complete available course workspace: lecture PDFs, assignments, solutions, sample exams, instructor notes, tutorials, labs, focus documents, and other relevant course material. Use unambiguous lecture identifiers in filenames.
3. Add `exam-workspace-bootstrap.skill`, `exam-material-extraction.skill`, and `exam-material-optimization.skill` as project-available skills. Their frontmatter names match their filenames and can be invoked directly in ChatGPT.
4. Before generating the first lecture deck, invoke the `exam-workspace-bootstrap` skill against the populated project. Keep its generated workspace index, exam-focus reference, and project instructions available to later chats; they provide the routing, source weighting, and exam-priority context used throughout the workflow.
5. Rerun bootstrap when the course workspace changes substantially, such as after adding a new training exam, a major assignment set, or revised official material.

Keep source roles distinct:

- Lecture slides are the source of truth during extraction.
- The extracted deck is the baseline during optimization.
- The bootstrap artifacts route agents to the relevant original sources and summarize evidence-backed exam priorities; they are aids, not replacement evidence.
- Non-slide course material supplies priority evidence and qualifying additions.
- Lecture slides are consulted during optimization only for targeted verification.
- General model knowledge and arbitrary web sources are excluded by default.

## Generate a Lecture Deck

Use the latest suitable ChatGPT model with extended thinking enabled:

1. Open a new chat in the bootstrapped course project and ask ChatGPT to use the `exam-material-extraction` skill for the target lecture. Name the lecture or PDF unambiguously.
2. Let extraction run until it either passes its page-coverage gate or returns a blocking/resume report. If blocked, ask it to load the previous checkpoint and continue in the same chat. Do not treat a partial CSV as complete.
3. Save the complete extraction CSV, including its header, as the raw deck. Keep the coverage summary separate from the CSV.
4. In the same project chat, ask ChatGPT to use the `exam-material-optimization` skill on the raw deck. The bootstrap index and exam-focus reference should guide source selection and prioritization, while substantive decisions remain grounded in the original course material.
5. Save the optimized CSV and its compression/provenance audit separately. Use the optimized deck as the baseline for manual review, not as an unquestioned final artifact.

Suggested filenames are `<lecture>-raw.csv` for extraction output and `<lecture>.csv` for optimized output.

## Optional Local Helper

`openai/ankify-openai.sh` is an optional clipboard helper for the direct workflow above. It copies thin launcher prompts, supplies a continuation prompt on demand, captures raw and optimized CSV from the clipboard, normalizes Unicode and ASCII arrows, and creates simple Markdown review copies. It does not bootstrap the project or replace either skill.

The helper additionally requires:

- Bash plus standard GNU/MinGW tools: `cat`, `dirname`, `realpath`, and `tee`
- The following [dotnet-scripts](https://github.com/frederik-hoeft/dotnet-scripts) utilities on `PATH`:
  - `eclip` for clipboard access
  - `esed` for .NET regular-expression replacements
  - `normalize` for Unicode-to-ASCII normalization

Run it from the repository root:

```bash
./openai/ankify-openai.sh lecture-02
```

`lecture-02` should uniquely identify the target PDF available in the ChatGPT project. Follow the terminal prompts:

1. Paste the initial clipboard contents into a new chat in the course project. Use the latest suitable model with extended thinking enabled.
2. Let extraction run until it either finishes or returns a blocking/resume report. If it is blocked, press Enter in the terminal, paste the continuation prompt that the script copies, and repeat in the same chat.
3. When extraction is complete, type `ok` at the terminal prompt. Copy **only the complete CSV**, including its header, from ChatGPT to the clipboard and press Enter. Do not include Markdown fences, the coverage summary, or commentary.
4. The script saves the raw deck and copies the optimization prompt. Paste that prompt into the same chat so the extracted deck and project material remain available as context.
5. Copy **only the optimized CSV**, including its header, to the clipboard and press Enter. Keep any separate compression/provenance audit in the chat or save it manually; the runner expects CSV clipboard content.

The helper writes these files under `openai/`:

| File | Contents |
| --- | --- |
| `openai/<lecture>-raw.csv` | Comprehensive extraction-stage deck |
| `openai/<lecture>-raw.md` | Human-readable rendering of the raw deck |
| `openai/<lecture>.csv` | Optimized deck intended as the manual-review baseline |
| `openai/<lecture>.md` | Human-readable rendering of the optimized deck |

Because the helper assumes a two-column quoted CSV and performs a simple regex-based CSV-to-Markdown conversion, copy only CSV content to the clipboard and inspect the resulting files before importing them into Anki.

## Card Contract

- CSV columns are `"Title","Backside"`, with every field double-quoted.
- Titles identify the recall target without being questions or revealing answers.
- The preferred title shape is `Topic: specific focus`.
- Fixed enumerations include their count and use numbered facts on the backside.
- Mathematics uses inline MathJax `\(...\)`.
- Administrative/meta slides and examples with no new examinable rule are skipped.
- Existing terminology, notation, assumptions, and source-supported ambiguity are preserved rather than silently corrected from outside knowledge.

## Legacy Universal Workflow

The `universal/` directory predates the skill-based OpenAI workflow. It contains a slide-index prompt and a card-generation prompt for an LLM-agnostic two-pass process, but it does not provide the current visual inspection, resumable per-page checkpointing, evidence-driven optimization, or workspace bootstrap. Treat it as historical/reference material rather than the recommended entry point.