#!/usr/bin/env bash
set -e
ollama create gherkin-genie -f Modelfile
echo "✅ gherkin-genie built. Run with: ollama run gherkin-genie"