# A Sample Workflow for AI-Assisted Self-Study

A structured self-study workflow for closed-book exam preparation, combining LLM-generated Anki flashcards with active lecture review and assignment practice.

## Prerequisites

- **ChatGPT** access to a suitable model with extended thinking, project file context, and support for the repository's skills
- **Anki** installed locally
- Lecture slides available as **PDF** files
- Relevant non-slide course material, where available: assignments, solutions, sample exams, instructor notes, tutorials, labs, and exam-focus documents

## One-Time Setup

1. **Create a ChatGPT project** dedicated to the course.
2. **Upload the complete available course workspace** so it remains available across chats. Include lecture PDFs, assignments, solutions, sample exams, instructor notes, tutorials, labs, focus documents, and other relevant course material.
3. **Add all workflow skills** from `openai/` to the project:
   - `exam-workspace-bootstrap.skill` inventories the workspace and establishes retrieval, source weighting, and exam-priority context.
   - `exam-material-extraction.skill` provides exhaustive, source-grounded card generation.
   - `exam-material-optimization.skill` is required for exam-focused refinement.
4. **Bootstrap the populated project before generating cards.** Invoke the `exam-workspace-bootstrap` skill once across the complete workspace. Let it inspect the actual sources and create the workspace index, exam-focus reference, and project-level instructions.
5. **Keep the generated bootstrap artifacts in the project** so later extraction, optimization, assignment-review, and study chats can use them. They should route agents to original sources and communicate source authority and exam priorities; they do not replace the original material as evidence.

Bootstrap is the normal entry point for a new course project, not an optional per-lecture enhancement. Rerun it when the workspace changes substantially, such as after adding a new exam, a major assignment set, or revised official material. `ankify-openai.sh` does not invoke it automatically.

## Per-Lecture Workflow

Repeat the following steps sequentially for each lecture:

### 1. Generate Anki Cards

Use the latest suitable ChatGPT model with **extended thinking** enabled. Generate each lecture deck through two direct skill invocations:

- **Phase 1 - extraction**: ChatGPT visually inspects every physical PDF page in order, creates source-grounded cards, and checkpoints every page, including pages that produce no cards. It must pass its final page-coverage gate before the deck is considered complete.
- **Phase 2 - optimization**: ChatGPT treats the extracted cards as the trusted lecture baseline, uses the bootstrap index and exam-focus reference for routing and prioritization, then consults authoritative non-slide course material to compress, restructure, and selectively enrich the deck. It should ground decisions in original course sources and consult lecture slides only to resolve a specific ambiguity or conflict.

Follow this sequence:

1. Open a new chat in the bootstrapped course project and ask ChatGPT to use the `exam-material-extraction` skill for the target lecture. Identify the lecture or PDF unambiguously.
2. If ChatGPT returns a blocking/resume report, ask it to load the previous checkpoint and continue in the same chat. Repeat until extraction passes its page-coverage gate.
3. Save the complete extraction CSV, including its header, as `<lecture>-raw.csv`. Keep coverage lines and commentary outside the CSV.
4. In the same project chat, ask ChatGPT to use the `exam-material-optimization` skill on the extracted deck.
5. Save the optimized CSV as `<lecture>.csv` and retain the separate compression/provenance audit for review.

Review both CSV files before importing or merging them. Skill output remains a draft requiring human judgment.

#### Optional Local Helper

`openai/ankify-openai.sh` can automate prompt copying, continuation prompts, clipboard capture, normalization, and creation of Markdown review copies. It is not required for the workflow and does not run workspace bootstrap. Its Bash and [dotnet-scripts](https://github.com/frederik-hoeft/dotnet-scripts) requirements are documented in the [README](../README.md#optional-local-helper).

```bash
./openai/ankify-openai.sh lecture-XX
```

When using it, follow the terminal prompts and copy only complete CSV content to the clipboard. The helper writes raw and optimized `.csv` and `.md` files under `openai/`.

### 2. Self-Study the Lecture + Merge Cards

Read through the lecture PDF once with a focus on **understanding the material**. As you study, use the raw and optimized CSV files (or the helper-generated Markdown copies) side-by-side with the lecture PDF to perform a manual **3-way merge** and produce a final `.csv`:

1. **Raw extraction cards** (Phase 1 output) - the comprehensive, lecture-grounded baseline produced from complete visual page coverage.
2. **Optimized cards** (Phase 2 output) - the evidence-prioritized base deck, potentially compressed, reorganized, or enriched from authoritative non-slide course material.
3. **Your manual edits** - additions, corrections, and removals based on your reading: anything that the LLM missed, you had questions about when reading the slides, or that you want to rephrase for better recall.

Merge these three as you read through the lecture, as soon as you fully understand the current slide or section. This way, you can ensure that the final Anki deck is comprehensive and accurate, while also being tailored to your understanding, recall preferences, and that it excludes any details you deem irrelevant or trivial by your own judgment.

For complex concepts, proofs, or processes (e.g., algorithms, handshake protocols, etc.), make sure to include cards that cover the **reasoning and logic** behind the concept, not just the raw steps or facts.

### 3. Import into Anki

Import the final `.csv` file into Anki as a new deck for the lecture.

### 4. Study the Deck

Work through the Anki deck for the lecture, until you can recall all/most cards from short-term memory.

### 5. Work Through Assignments

Complete related assignments primarily from memory, using the lecture slides only as reference when needed.

### 6. Review Assignments with ChatGPT

Within the same ChatGPT project (to retain lecture context), open a new chat with **extended thinking** enabled or use the same chat from the corresponding lecture's Anki generation, to reuse the same context window with the lecture slides and cards. Then:

- Upload the assignment sheet(s) into the chat.
- Discuss your answers and reasoning with the LLM.
- Only accept LLM feedback if:
  - It is consistent with the lecture material and your understanding.
  - It provides clear reasoning and evidence for why an answer is correct or incorrect (e.g., following the logic of a proof, or referencing specific slides).
  - Otherwise: 
    - Discuss and debate the LLM's feedback until:
      - You are satisfied with the reasoning and evidence provided, and learned something new, or
      - You are confident in your original answer and reasoning, and can articulate why the LLM's feedback is incorrect or less optimal.
      - The LLM corrects itself and provides improved feedback after discussion.
    - Verify the feedback in question with external resources (e.g., textbooks, online references) if needed to resolve disagreements.
    - Send your professor an email if there is a significant uncertainty about some concept or question, and ask for clarification.
  - Treat the LLM as a peer reviewer or study partner. Unless it can provide clear reasoning or authoritative evidence for its feedback, do not treat it as an authority that must be followed. Use it in a "pair programming" style, to discuss and debate the material until you are satisfied with your understanding and reasoning, whether that is based on your original answer or an improved answer after discussion with the LLM.
- If provided answers exist from the lecture, upload those as well and compare against your own.
- As you gain new insights from the assignments and discussions, consider adding or clarifying cards in the Anki deck to reinforce those insights.

### 7. Continue

Move on to the next lecture and repeat from [step 1](#1-generate-anki-cards).

### 8. Review

Periodically review the Anki decks for all lectures, and re-study any lectures or assignments as needed to reinforce understanding and retention.