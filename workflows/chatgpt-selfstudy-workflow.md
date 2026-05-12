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

### 2. Self-Study the Lecture + Merge Cards

Read through the lecture PDF once with a focus on **understanding the material**. As you study, use the `.md` or `.csv` files side-by-side with the lecture PDF to perform a (manual) **3-way merge** of the generated Anki cards to produce a final `.csv`:

1. **Raw LLM cards** (Phase 1 output) - the unfiltered, comprehensive card set: whatever the LLM initially considered relevant from the slides.
2. **Optimized LLM cards** (Phase 2 output) - the compressed/cleaned card set: usually a good base-line, but may have dropped some details or nuance.
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
  - Treat the LLM as a peer reviewer or study partner. Unless it can provide clear reasoning or authorative evidence for its feedback, do not treat it as an authority that must be followed. Use it in a "pair programming" style, to discuss and debate the material until you are satisfied with your understanding and reasoning, whether that is based on your original answer or an improved answer after discussion with the LLM.
- If provided answers exist from the lecture, upload those as well and compare against your own.

### 7. Continue

Move on to the next lecture and repeat from [step 1](#1-generate-anki-cards).

### 8. Review

Periodically review the Anki decks for all lectures, and re-study any lectures or assignments as needed to reinforce understanding and retention.