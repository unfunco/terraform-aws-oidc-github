#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v terraform >/dev/null 2>&1; then
  >&2 echo "Error: Missing terraform."
  exit 1
fi

if ! command -v terraform-docs >/dev/null 2>&1; then
  >&2 echo "Error: Missing terraform-docs."
  exit 1
fi

prettier=()

if command -v bunx >/dev/null 2>&1; then
  prettier=(bunx prettier)
elif command -v npx >/dev/null 2>&1; then
  prettier=(npx prettier)
else
  >&2 echo "Error: Missing a Bun or Node.js distribution."
  exit 1
fi

terraform fmt -recursive
terraform-docs .

"${prettier[@]}" --write README.md
