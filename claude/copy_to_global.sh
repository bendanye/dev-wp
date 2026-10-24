#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

for dir in agents commands skills; do
  mkdir -p ~/.claude/"$dir"
  rsync -a --exclude '.DS_Store' "$dir"/ ~/.claude/"$dir"/
done

echo "Installed agents, commands and skills to ~/.claude"
