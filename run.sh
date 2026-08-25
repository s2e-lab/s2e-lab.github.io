#!/usr/bin/env bash

set -euo pipefail

if [[ -n "${RUBY_ROOT:-}" && -x "${RUBY_ROOT}/bin/bundle" ]]; then
  BUNDLE="${RUBY_ROOT}/bin/bundle"
else
  BUNDLE="$(command -v bundle)"
fi

exec "${BUNDLE}" exec jekyll serve --livereload "$@"
