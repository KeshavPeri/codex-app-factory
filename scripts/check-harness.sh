#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

required_files='AGENTS.md
.codex/config.toml
.codex/agents/product_manager.toml
.codex/agents/builder.toml
.codex/agents/qa.toml
.agents/skills/codex-app-factory/SKILL.md
.agents/skills/codex-app-factory/agents/openai.yaml
templates/app/AGENTS.md
templates/app/.github/ISSUE_TEMPLATE/feature.yml
templates/app/.github/workflows/ci.yml
templates/app/.github/workflows/pages.yml
templates/app/docs/product-brief.md
templates/app/docs/design-reference.md
templates/app/docs/decisions.md
templates/app/factory/AUTOMATION-PROMPT.md
templates/app/factory/REVIEW-PACKET.md
templates/app/scripts/configure-github.sh'

printf '%s\n' "$required_files" | while IFS= read -r file; do
  if [ ! -s "$root/$file" ]; then
    printf 'Missing or empty: %s\n' "$file" >&2
    exit 1
  fi
done

for agent in "$root/.codex/agents/"*.toml; do
  python3 - "$agent" <<'PY'
import sys
import tomllib

path = sys.argv[1]
with open(path, "rb") as handle:
    data = tomllib.load(handle)
for key in ("name", "description", "developer_instructions"):
    if not data.get(key):
        raise SystemExit(f"{path}: missing {key}")
PY
done

if rg -n 'TODO|\[TODO' "$root" --glob '!scripts/check-harness.sh'; then
  printf 'Unfinished scaffold marker found.\n' >&2
  exit 1
fi

printf 'Harness structure and agent TOML validated.\n'
