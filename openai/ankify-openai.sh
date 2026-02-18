#!/usr/bin/env bash

# Convert LLM-generated Anki flashcards for the specified lecture into CSV and Markdown format

# sane bash behavior
set -euo pipefail

# get argument (e.g., "lecture-02", refers to lecture powerpoint PDF and must be available to the LLM for card generation)
lecture="${1:-}"

# get script directory
script_dir="$(/usr/bin/realpath "$(/usr/bin/dirname "${BASH_SOURCE[0]}")")"

# copy first part of prompt template to clipboard
cat "${script_dir}/prompt-openai-1.md" | esed "s/{LECTURE}/${lecture}/" | eclip set
# wait for user input before proceeding
read -rp "Paste clipboard contents into LLM prompt, press Enter after copying LLM output to clipboard..."
eclip get | normalize | esed 's/->/\\\(\\to\\\)/' | tee "${script_dir}/${lecture}-raw.csv" \
| esed 's/^"/#### /' | esed 's/","/\n\n/' | esed 's/"(?=\r?\n)/\n/' > "${script_dir}/${lecture}-raw.md"
# copy second part of prompt template to clipboard
cat "${script_dir}/prompt-openai-2.md" | esed "s/{LECTURE}/${lecture}/" | eclip set
# wait for user to copy LLM output
read -rp "Paste clipboard contents into LLM prompt, press Enter after copying LLM output to clipboard..."
# save clipboard content to CSV file
# run unicode normalization (kick out emojis / weird non-ascii quotes) and arrow substitution (normalized ascii to LaTeX) pipeline
# convert to Markdown for review (sequential regex passes)
eclip get | normalize | esed 's/->/\\\(\\to\\\)/' | tee "${script_dir}/${lecture}.csv" \
| esed 's/^"/#### /' | esed 's/","/\n\n/' | esed 's/"(?=\r?\n)/\n/' > "${script_dir}/${lecture}.md"
# final message
echo "LLM-generated Anki cards saved to ${script_dir}/${lecture}.csv and ${script_dir}/${lecture}.md."
echo 'Preferably also manually review the cards yourself'