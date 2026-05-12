# Exam Prep Workflow: ChatGPT Plus + Anki

A structured self-study workflow for closed-book exam preparation, combining LLM-generated Anki flashcards with active lecture review and assignment practice.

## Prerequisites

- **ChatGPT Plus** subscription (access to latest GPT model with extended thinking)
- **Anki** installed locally
- Lecture slides available as **PDF** files
- The `openai/ankify-openai.sh` script and its dependencies (see [README](../README.md#prerequisites))

## One-Time Setup

1. **Create a ChatGPT project** dedicated to the course.
2. **Upload all lecture PDFs** into the project workspace so they are available as shared context across chats.

## Per-Lecture Workflow

Repeat the following steps sequentially for each lecture:

### 1. Generate Anki Cards

Run the provided bash script for the current lecture:

```bash
./openai/ankify-openai.sh lecture-XX
```

where `lecture-XX` should partially match the filename of the lecture PDF (e.g., `lecture-02` for `cs101-lecture-02-introduction.pdf`).

Use the latest GPT model with **extended thinking** enabled. The script guides you through a two-phase prompting process:

- **Phase 1**: The LLM visually inspects every slide and generates flashcards with checkpointing. If ChatGPT stalls due to internal timeouts, rate limits, or tool failures (e.g., `BLOCKED` with `REASON=tool_auth_failure`), send `Load previous checkpoint and continue` in the same chat (provided by the script) to resume from the last successful checkpoint without losing progress. Copy the generated CSV to the clipboard when finished.
- **Phase 2**: The script copies a review/optimization prompt. Paste it in the same chat to compress and clean up the cards. Copy the final CSV output to the clipboard.

The script saves both raw and cleaned outputs as `.csv` and `.md` files.

### 2. Self-Study the Lecture + Review Cards

Read through the lecture PDF once with a focus on **understanding the material**, while verifying the generated Anki cards on the side (using the `.md` file or the CSV):

- Ensure no important details were omitted by the LLM.
- Optimize card titles and descriptions for personal learning effectiveness.
- Remove cards that are unnecessary or redundant.
- Cards should include enough context for you to remember the material + reasoning as to why that answer is correct.

Create a final `.csv` merging the raw and optimized LLM CSVs and your own edits.

### 3. Import into Anki

Import the final `.csv` file into Anki as a new deck for the lecture.

### 4. Study the Deck

Work through the Anki deck for the lecture, until you can recall all/most cards from short-term memory.

### 5. Work Through Assignments

Complete related assignments primarily from memory, using the lecture slides only as reference when needed.

### 6. Review Assignments with ChatGPT

Within the same ChatGPT project (to retain lecture context), open a new chat with **extended thinking** enabled:

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
- If provided answers exist from the lecture, upload those as well and compare against your own.

### 7. Continue

Move on to the next lecture and repeat from [step 1](#1-generate-anki-cards).

### 8. Review

Periodically review the Anki decks for all lectures, and re-study any lectures or assignments as needed to reinforce understanding and retention.