#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
SMOKE_ROOT="$REPO_ROOT/.smoke/"
BIN="$REPO_ROOT/.build/release/cs"

cd "$REPO_ROOT"
rm -rf "$SMOKE_ROOT"
mkdir -p "$SMOKE_ROOT"
cd "$SMOKE_ROOT"

# === good ones ===

$BIN "seems legit?"
echo -n 'seems legit?' | $BIN -

cmp "seems-legit-question-mark.png" "seems-legit-question-mark (1).png"

$BIN "lorem ipsum dolor sit amet" --padding 16 --vertical top --horizontal trailing
echo -n 'lorem ipsum dolor sit amet' | $BIN --padding 16 --vertical top --horizontal trailing -

cmp "lorem-ipsum-dolor-sit-amet.png" "lorem-ipsum-dolor-sit-amet (1).png"

$BIN "dog" --output "sup"
$BIN "dog" --output "./sup"
$BIN "dog" --output "$(pwd)/sup" # absolute
(cd ./sup/ && $BIN "dog" --output "../")

cmp "sup/dog.png" "dog.png"
cmp "sup/dog.png" "sup/dog (1).png"
cmp "sup/dog.png" "sup/dog (2).png"

# === errors ===

expect_non_zero() {
  local exit_code="$1"
  local message="$2"

  if [[ "$exit_code" -eq 0 ]]; then
    echo "$(tput setaf 1)$message$(tput sgr0)"
    exit 1
  fi
}

set +e

$BIN
expect_non_zero "$?" "Expected non-zero exit code for missing arg"

$BIN -
expect_non_zero "$?" "Expected non-zero exit code for missing pipe"

$BIN "sup" --output "dog.png"
expect_non_zero "$?" "Expected non-zero exit code for output being an existing file path"

set -e

echo "$(tput setaf 2)All tests passed$(tput sgr0)"
