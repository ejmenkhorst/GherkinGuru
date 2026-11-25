<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-wordmark-dark.svg">
    <img src="assets/logo-wordmark.svg" alt="GherkinGuru" width="480">
  </picture>
</p>

A local, offline AI guru for writing rule-compliant BDD Gherkin scenarios.
  
Gherkin Guru is a tool that turns plain descriptions of a feature into properly written test scenarios (Gherkin/BDD format).  

It automatically strips out technical details — button clicks, dropdowns, API calls — and rewrites them as plain business behavior: not "clicks the login button" but "the user logs in."
  
This matters because test scenarios should describe what the system does for the user, not how the screen works.

That way, when the UI changes, the scenarios don't break, and anyone — developer, tester, or business analyst — can read and understand them without technical knowledge.

## Requirements

| Requirement | Purpose |
| --- | --- |
| [Ollama](https://ollama.com) | Runs the language model locally, so nothing leaves your machine. |
| [OpenCode](https://opencode.ai) | The coding agent you talk to. It loads the `gherkin-review` skill from `.opencode/skills/` and connects to Ollama through `opencode.json`. |
| `mistral-small:24b` model | The default model configured in `opencode.json`. It needs about 16GB of free RAM or VRAM. |

## Setup

```bash
# Step 1: Clone the project
git clone https://github.com/ejmenkhorst/GherkinGuru.git
cd GherkinGuru

# Step 2: Download the local model
ollama pull mistral-small:24b

# Step 3: Install OpenCode (other install options: https://opencode.ai/docs)
curl -fsSL https://opencode.ai/install | bash
```

There is no build step. OpenCode reads `opencode.json` and the skills in `.opencode/skills/` from the project folder when it starts.

## Run GherkinGuru

Make sure Ollama is running, then start OpenCode from the project root:

```bash
opencode
```

Ask it to write or review Gherkin, for example:

```text
Review features/place-order.feature
```

```text
Write scenarios for this story: as a customer I want free shipping on orders above 50 euros
```

OpenCode loads the `gherkin-review` skill and edits the `.feature` file directly, giving a short reason for each change.

### Troubleshooting

If OpenCode answers but doesn't edit files or load the skill, Ollama's context window may be too small for the agent's tool calls. Quit the Ollama app, then start Ollama with a larger context window:

```bash
OLLAMA_CONTEXT_LENGTH=32768 ollama serve
```

## Rules

See [.opencode/skills/gherkin-review/SKILL.md](.opencode/skills/gherkin-review/SKILL.md) for the full style guide the agent follows.

## How GherkinGuru Works

### Three parts

- **Ollama** runs the model (`mistral-small:24b`) on your machine. The model weights are downloaded once per machine with `ollama pull` and are never stored in Git.
- **OpenCode** is the agent. It reads and edits files in the project and sends your requests to the model. `opencode.json` points it at Ollama's local endpoint (`http://localhost:11434/v1`) and sets `mistral-small:24b` as the default model.
- **The `gherkin-review` skill** holds the rules. OpenCode sees each skill's name and description, and when you ask it to write or review Gherkin it loads the full `SKILL.md` and follows it.

No retraining or model build happens. Everyone runs the same downloaded model; the skill is a set of instructions the agent reads when the task calls for it.

### What Git actually distributes

Not the model — the **configuration**:

| In Git | Not in Git |
| --- | --- |
| `opencode.json` | Model weights (GBs) |
| `.opencode/skills/` | Ollama and OpenCode |
| `features/`, `README.md` | |

Coworkers clone the repo, pull the model and install OpenCode themselves, and get the same rules without anyone shipping anything heavy.

### One source of truth

`SKILL.md` is the only copy of the rules. It's what the agent reads and what people read and edit in pull requests.

### The feedback loop

Edit `SKILL.md` → start a new OpenCode session → test on a `.feature` file → commit/push
→ coworkers pull → same rules everywhere

Ollama does the heavy lifting (running the model) and OpenCode does the file work. Your repo just carries the *instructions* for their behavior — small, readable, and version-controlled like normal code.

## Contributing

Rule changes go in [.opencode/skills/gherkin-review/SKILL.md](.opencode/skills/gherkin-review/SKILL.md). Before committing, start a new OpenCode session, ask it to review a sample such as `features/place-order.feature`, and check that the result follows the rules. Discard the edit to the sample afterwards with `git restore features/place-order.feature`.

## License

MIT — see [LICENSE](LICENSE).
