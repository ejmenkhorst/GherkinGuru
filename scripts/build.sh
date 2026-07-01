#!/usr/bin/env bash
set -e
ollama create gherkin-guru -f Modelfile
echo "✅ Gherkin-guru built successfully." 
echo "✅ Run with: ollama run gherkin-guru"
