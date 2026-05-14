#!/usr/bin/env bash
# Apply the modernization to peczenyj/Frequency.
#
# Run this from a fresh clone of the repository:
#
#   git clone https://github.com/peczenyj/Frequency.git
#   cd Frequency
#   unzip ../frequency-modernize.zip   # extracts payload/ next to this script
#   bash payload/apply.sh
#
# After it runs, review the changes (`git status`, `git diff master`), then:
#
#   git push -u origin modernize-2026
#
# and open a PR on GitHub.

set -euo pipefail
IFS=$'\n\t'

BRANCH="modernize-2026"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -d .git ]]; then
  echo "error: run this from the root of your Frequency clone" >&2
  exit 1
fi

# Refuse to clobber uncommitted work.
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "error: working tree is dirty; commit or stash first" >&2
  exit 1
fi

# Create the branch off whatever is currently checked out (should be master).
git checkout -b "$BRANCH"

# --- Remove the things we're replacing ---
git rm -rf rdoc 2>/dev/null || true
git rm -f README.rdoc 2>/dev/null || true

# --- Copy in the new files ---
mkdir -p lib spec bin .github/workflows

cp "$HERE/lib/frequency.rb"            lib/frequency.rb
cp "$HERE/spec/frequency_spec.rb"      spec/frequency_spec.rb
cp "$HERE/spec/spec_helper.rb"         spec/spec_helper.rb
cp "$HERE/bin/setup"                   bin/setup
cp "$HERE/bin/console"                 bin/console
cp "$HERE/.github/workflows/ci.yml"    .github/workflows/ci.yml
cp "$HERE/.github/workflows/release.yml" .github/workflows/release.yml

cp "$HERE/frequency-dsl.gemspec"  frequency-dsl.gemspec
cp "$HERE/Gemfile"                Gemfile
cp "$HERE/Rakefile"               Rakefile
cp "$HERE/.rspec"                 .rspec
cp "$HERE/.rubocop.yml"           .rubocop.yml
cp "$HERE/.gitignore"             .gitignore
cp "$HERE/README.md"              README.md
cp "$HERE/CHANGELOG.md"           CHANGELOG.md

chmod +x bin/setup bin/console

# VERSION file is now sourced from Frequency::VERSION but keep it in sync
# in case anything reads it.
echo "0.2.0" > VERSION

git add -A
git commit -m "Modernize gem: Ruby 3.1+, RSpec 3, CI matrix, RubyGems trusted publishing

BREAKING:
- with_probability is now a keyword argument
- Invalid probability raises Frequency::InvalidProbabilityError (was RuntimeError)
- Minimum Ruby is 3.1

Added:
- Frequency.random= and Frequency.with_seed for reproducible runs
- Module-function call style (Frequency.sometimes { ... })
- GitHub Actions CI matrix (Ruby 3.1-3.4) on every push and PR
- GitHub Actions release workflow using RubyGems trusted publishing (OIDC)
- RuboCop config and lint job
- Markdown README and CHANGELOG

Fixed:
- Percent regex was unanchored on '.' (any char) instead of '\\.';
  malformed inputs like '50x5%' now correctly raise
- Probability validation produces a typed error

Removed:
- Jeweler dependency, committed rdoc/ directory, README.rdoc"

echo ""
echo "Branch '$BRANCH' is ready. Next:"
echo ""
echo "  git diff master   # review"
echo "  git push -u origin $BRANCH"
echo ""
echo "Then open a PR on GitHub. The CI workflow will run automatically against"
echo "Ruby 3.1, 3.2, 3.3, and 3.4."
