#!/bin/sh
set -eu

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  printf 'Usage: %s /absolute/path/to/new-app [profile]\n' "$0" >&2
  printf 'Profiles: generic (default), static-web\n' >&2
  exit 2
fi

target=$1
profile=${2:-generic}
case "$target" in
  /*) ;;
  *)
    printf 'Target must be an absolute path.\n' >&2
    exit 2
    ;;
esac

factory_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

case "$profile" in
  generic|static-web) ;;
  *)
    printf 'Unknown profile: %s\n' "$profile" >&2
    exit 2
    ;;
esac

if [ -e "$target" ] && [ "$(find "$target" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
  printf 'Target exists and is not empty: %s\n' "$target" >&2
  exit 1
fi

mkdir -p "$target"
cp -R "$factory_root/templates/app/." "$target/"
mkdir -p "$target/.codex/agents" "$target/.agents/skills"
cp "$factory_root/.codex/config.toml" "$target/.codex/config.toml"
cp "$factory_root/.codex/agents/"*.toml "$target/.codex/agents/"
cp -R "$factory_root/.agents/skills/codex-app-factory" "$target/.agents/skills/"
if [ "$profile" != 'generic' ]; then
  cp -R "$factory_root/templates/profiles/$profile/." "$target/"
fi
chmod +x "$target/scripts/configure-github.sh"

if command -v git >/dev/null 2>&1; then
  git init -b main "$target" >/dev/null
fi

printf 'Created Codex app workspace at %s using profile %s\n' "$target" "$profile"
printf 'Next: complete docs/product-brief.md, then add the app code and smoke ticket.\n'
