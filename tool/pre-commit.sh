#!/usr/bin/env bash
#
# Pre-commit gate: format -> analyze -> test.
# Mirrors the CI job in .github/workflows/flutter_ci.yml, so anything that
# passes here passes there.
#
# Install:  ./tool/pre-commit.sh --install
# Skip once: git commit --no-verify

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

if [[ "${1:-}" == "--install" ]]; then
  mkdir -p .git/hooks
  ln -sf ../../tool/pre-commit.sh .git/hooks/pre-commit
  chmod +x tool/pre-commit.sh
  echo "✓ pre-commit hook installed"
  exit 0
fi

fail() { echo "✗ $1" >&2; exit 1; }

echo "→ dart format"
find lib test -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart' -print0 \
  | xargs -0 dart format --set-exit-if-changed >/dev/null \
  || fail "Formatting issues. Run: dart format ."

echo "→ flutter analyze"
flutter analyze --fatal-infos --fatal-warnings \
  || fail "Analyzer issues. Run: dart fix --apply"

echo "→ flutter test"
flutter test || fail "Tests failed."

echo "✓ all checks passed"
