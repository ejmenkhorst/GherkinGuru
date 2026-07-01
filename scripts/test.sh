#!/usr/bin/env bash
set -uo pipefail

# Regression tests for the GherkinGuru SYSTEM prompt. Run after any
# Modelfile edit + rebuild to catch output-format and banned-word
# regressions before they ship.
#
# Usage: scripts/test.sh [model-name]   (default: gherkin-guru)

MODEL="${1:-gherkin-guru}"
OLLAMA_URL="http://localhost:11434/api/generate"

# Mirrors the BANNED WORDS list in the Modelfile's SYSTEM prompt (rule 4).
# Keep these two lists in sync when the style guide changes.
BANNED_WORDS_REGEX='\b(click|clicks|clicking|press|presses|pressing|tap|taps|tapping|select|selects|selecting|check|checks|checking|submit|submits|submitting|button|field|dropdown|menu|checkbox|toggle|toggles|form|scroll|scrolls|drag|drags|swipe|swipes|hover|hovers|box|switch|api|database|backend|endpoint|token|session|payload)\b'

pass_count=0
fail_count=0

run_model() {
  local prompt="$1"
  curl -s "$OLLAMA_URL" \
    -d "$(jq -n --arg model "$MODEL" --arg prompt "$prompt" '{model: $model, prompt: $prompt, stream: false}')" \
    | jq -r '.response'
}

check() {
  local name="$1" input="$2"
  shift 2
  local output
  output="$(run_model "$input")"

  local failures=()

  if [[ "$output" != Feature:* ]]; then
    failures+=("does not start with 'Feature:'")
  fi
  if [[ "$output" == *'`'* ]]; then
    failures+=("contains a backtick / code fence")
  fi

  local hits
  hits="$(grep -inoE "$BANNED_WORDS_REGEX" <<<"$output" | sort -u | tr '\n' ',' | sed 's/,$//')"
  if [[ -n "$hits" ]]; then
    failures+=("banned word(s) leaked: $hits")
  fi

  # Remaining args are extra substrings that must be present (structural checks).
  local extra
  for extra in "$@"; do
    if [[ "$output" != *"$extra"* ]]; then
      failures+=("missing required text: '$extra'")
    fi
  done

  if [[ ${#failures[@]} -eq 0 ]]; then
    echo "PASS  $name"
    pass_count=$((pass_count + 1))
  else
    echo "FAIL  $name"
    local f
    for f in "${failures[@]}"; do
      echo "        - $f"
    done
    echo "      --- output ---"
    sed 's/^/      /' <<<"$output"
    echo "      --------------"
    fail_count=$((fail_count + 1))
  fi
}

check "login_button" \
  "Can you generate a happy flow scenario where a user needs to login with valid credentials to a login page when the clicks on the login button he should see this profile page."

check "payment_dropdown_field_api" \
  "The user selects a payment method from a dropdown, types their card number into a field, and presses the pay button, which calls the payment API and returns a success response code; the user then sees a confirmation screen."

check "role_discount_outline" \
  "A shopper with a bronze, silver, or gold membership gets a different discount percentage at checkout depending on their tier." \
  "Scenario Outline" "Examples:"

check "checkbox_session" \
  "The user checks the 'remember me' checkbox and clicks submit, then their session stays active for 30 days."

check "search_box_button" \
  "The user fills in the search box and clicks the search button to see a list of results."

echo
echo "$pass_count passed, $fail_count failed"
[[ $fail_count -eq 0 ]]
