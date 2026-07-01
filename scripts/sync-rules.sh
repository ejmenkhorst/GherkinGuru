#!/usr/bin/env bash
set -e

RULES_FILE="rules/gherkin-style-guide.md"
MODELFILE="Modelfile"
START_MARKER="<!-- SYNC:START -->"
END_MARKER="<!-- SYNC:END -->"

python3 - "$MODELFILE" "$RULES_FILE" "$START_MARKER" "$END_MARKER" <<'EOF'
import sys

modelfile_path, rules_path, start_marker, end_marker = sys.argv[1:5]

with open(rules_path) as f:
    rules = f.read().strip()

with open(modelfile_path) as f:
    content = f.read()

start = content.index(start_marker) + len(start_marker)
end = content.index(end_marker, start)

new_content = content[:start] + "\n" + rules + "\n" + content[end:]

with open(modelfile_path, "w") as f:
    f.write(new_content)

print(f"✅ Modelfile synced from {rules_path}")
EOF