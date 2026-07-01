#!/usr/bin/env bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ollama create gherkin-guru -f "$SCRIPT_DIR/../Modelfile"
echo "✅ Gherkin-guru built successfully."

echo
echo "Running regression tests..."
if ! "$SCRIPT_DIR/test.sh" gherkin-guru; then
  echo "❌ Regression tests failed — gherkin-guru was rebuilt, but its behavior has regressed. See failures above." >&2
  exit 1
fi

echo "✅ You can run Gherkin-guru with the following command: ollama run gherkin-guru"
