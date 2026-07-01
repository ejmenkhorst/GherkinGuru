# GherkinGuru
A local, offline AI genie for writing rule-compliant BDD Gherkin scenarios.  
Consistent Given/When/Then, zero cloud dependency.

## Requirements
- Ollama installed (https://ollama.com)
- ~8GB free RAM/VRAM for the default model (qwen2.5:7b-instruct)
  - Low-spec fallback: qwen2.5:3b-instruct

## Setup
\`\`\`bash
git clone <repo-url>
cd gherkin-genie
ollama pull qwen2.5:7b-instruct
./scripts/build.sh
\`\`\`

## Usage
\`\`\`bash
ollama run gherkin-genie
\`\`\`

## Rules
See [rules/gherkin-style-guide.md](rules/gherkin-style-guide.md) for the full
style guide enforced by this model.

## Examples
See the [examples/](examples/) folder for sample output.

## Contributing
Rule changes go in `rules/gherkin-style-guide.md` and must be mirrored in the
`SYSTEM` prompt inside `Modelfile`.

## License
MIT — see [LICENSE](LICENSE).
