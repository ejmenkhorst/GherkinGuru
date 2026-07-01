<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-wordmark-dark.svg">
    <img src="assets/logo-wordmark.svg" alt="GherkinGuru" width="480">
  </picture>
</p>

A local, offline AI guru for writing rule-compliant BDD Gherkin scenarios.  
GherkinGuru is a tool that turns plain descriptions of a feature into properly written test scenarios (Gherkin/BDD format).  
It automatically strips out technical details — button clicks, dropdowns, API calls — and rewrites them as plain business behavior: not "clicks the login button" but "the user logs in."  
This matters because test scenarios should describe what the system does for the user, not how the screen works.

That way, when the UI changes, the scenarios don't break, and anyone — developer, tester, or business analyst — can read and understand them without technical knowledge.


## Requirements

- Ollama installed ([https://ollama.com](https://ollama.com))
- ~8GB free RAM/VRAM for the default model (qwen2.5:7b-instruct)
  - Low-spec fallback: qwen2.5:3b-instruct

## Setup

```bash
# Step 1: Clone the project.
git clone https://github.com/ejmenkhorst/GherkinGuru.git
cd gherkin-guru

# Step 2: Install local model
ollama pull qwen2.5:7b-instruct

# Step 3: Build the local gherking-guru model
chmod +x scripts/build.sh
./scripts/build.sh
```

## Run gherking-guru locally

```bash
ollama run gherkin-guru
```

## Rules

See the `SYSTEM` block in [Modelfile](Modelfile) for the full style guide
enforced by this model.

## How GherkinGuru Works

### Base model vs. Modelfile

Ollama separates the "brain" from the "personality":

- The **base model** (`qwen2.5:7b-instruct`) is the actual neural network — downloaded once per machine via `ollama pull`. It's never stored in Git.
- The **Modelfile** is a tiny recipe: it tells Ollama to take that base model and permanently attach a `SYSTEM` prompt (your Gherkin rules) plus settings like low temperature for consistency.

Running ```ollama create gherkin-guru -f Modelfile``` bakes those rules into a new named model. No retraining happens — it's the same model, just always given your instructions before it sees a prompt.

### What Git actually distributes

Not the model — the **configuration**:

| In Git | Not in Git |
| --- | --- |
| `Modelfile` | Base model weights (GBs) |
| `README.md`, scripts | Generated output |
| | Ollama itself |

Coworkers clone the repo, pull the base model themselves, then run your Modelfile to get an identically-configured model — without you shipping anything heavy.

### One source of truth

The `SYSTEM` block in the `Modelfile` is the only copy of the rules — it's
what both the model reads and what humans read/edit in pull requests.

### The feedback loop

Edit the Modelfile's `SYSTEM` block → rebuild → test → commit/push
→ coworkers pull → rebuild → same fix everywhere

Ollama does the heavy lifting (running the model). Your repo just carries the *instructions* for its behavior — small, readable, and version-controlled like normal code.

## Contributing

Rule changes go directly in the `SYSTEM` block inside `Modelfile`, then
rebuild with `./scripts/build.sh` and test before committing.

## License

MIT — see [LICENSE](LICENSE).
