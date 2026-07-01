# GherkinGuru

A local, offline AI genie for writing rule-compliant BDD Gherkin scenarios.  
Consistent Given/When/Then, zero cloud dependency.

## Requirements

- Ollama installed ([https://ollama.com](https://ollama.com))
- ~8GB free RAM/VRAM for the default model (qwen2.5:7b-instruct)
  - Low-spec fallback: qwen2.5:3b-instruct

## Setup

```bash
# Step 1: Clone the project.
git clone https://github.com/ejmenkhorst/GherkinGuru.git
cd gherkin-genie

# Step 2: Install local model
ollama pull qwen2.5:7b-instruct

# Step 3: Build the local gherking-genie model
chmod +x scripts/build.sh scripts/sync-rules.sh hooks/pre-commit
git config core.hooksPath hooks
./scripts/build.sh
```

## Run gherking-genie locally

```bash
ollama run gherkin-genie
```

## Rules

See [rules/gherkin-style-guide.md](rules/gherkin-style-guide.md) for the full
style guide enforced by this model.

## How GherkinGenie Works

### Base model vs. Modelfile

Ollama separates the "brain" from the "personality":

- The **base model** (`qwen2.5:7b-instruct`) is the actual neural network — downloaded once per machine via `ollama pull`. It's never stored in Git.
- The **Modelfile** is a tiny recipe: it tells Ollama to take that base model and permanently attach a `SYSTEM` prompt (your Gherkin rules) plus settings like low temperature for consistency.

Running ```ollama create gherkin-genie -f Modelfile``` bakes those rules into a new named model. No retraining happens — it's the same model, just always given your instructions before it sees a prompt.

### What Git actually distributes

Not the model — the **configuration**:

| In Git | Not in Git |
| --- | --- |
| `Modelfile` | Base model weights (GBs) |
| `rules/style-guide.md` | Generated output |
| `README.md`, scripts | Ollama itself |

Coworkers clone the repo, pull the base model themselves, then run your Modelfile to get an identically-configured model — without you shipping anything heavy.

### Two copies of the rules

- `SYSTEM` prompt in the Modelfile → what the **model reads**.
- `rules/gherkin-style-guide.md` → what **humans read/edit** in pull requests.

Update both when rules change — that's the tradeoff for keeping each one readable in its own format.

### The feedback loop

Edit style guide → mirror automatically via pre-commit hook the Modelfile → rebuild → test → commit/push
→ coworkers pull → rebuild → same fix everywhere

Ollama does the heavy lifting (running the model). Your repo just carries the *instructions* for its behavior — small, readable, and versionable like normal code.

## Examples

See the [examples/](examples/) folder for sample output.

## Contributing

Rule changes go in `rules/gherkin-style-guide.md` and must be mirrored in the
`SYSTEM` prompt inside `Modelfile`.

## License

MIT — see [LICENSE](LICENSE).
