# Frequency

[![CI](https://github.com/peczenyj/Frequency/actions/workflows/ci.yml/badge.svg)](https://github.com/peczenyj/Frequency/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/frequency-dsl.svg)](https://rubygems.org/gems/frequency-dsl)

A small DSL written in Ruby to execute blocks with controlled probability —
`never`, `rarely`, `sometimes`, `normally`, `always`.

Useful for sampled logging, chaos testing, demo data generation, or any time
you want a side effect to happen "occasionally."

## Installation

```ruby
# Gemfile
gem "frequency-dsl"
```

```sh
bundle install
# or
gem install frequency-dsl
```

## Usage

Two styles are supported. Pick whichever you like:

```ruby
require "frequency"

# Module-function style (recommended for libraries):
Frequency.sometimes { puts "maybe" }
Frequency.rarely(with_probability: 0.01) { puts "very rare" }
Frequency.normally(with_probability: "24%") { puts "string percent works too" }

# Mixin style (convenient at the script level):
include Frequency

always   { puts "hi" }
sometimes { puts "maybe" }
never    { puts "this never prints" }
maybe    { puts "alias of sometimes" }
```

The `with_probability:` keyword accepts:

- a Float in `[0, 1]` — `0.42`
- a String percent — `"42%"` or `"42.5%"`
- a String number — `"0.42"`

It is ignored by `always` and `never`, which are unconditional.

### Reproducible runs

Inject your own RNG:

```ruby
Frequency.random = Random.new(42)
```

Or scope a seed to a single block:

```ruby
Frequency.with_seed(42) do
  10.times { Frequency.sometimes { puts "deterministic" } }
end
```

### Errors

Bad probabilities raise `Frequency::InvalidProbabilityError`
(a subclass of `Frequency::Error < StandardError`):

```ruby
Frequency.sometimes(with_probability: "101%") { ... }
# => Frequency::InvalidProbabilityError: probability must be in [0, 1], got 1.01

Frequency.sometimes(with_probability: :half) { ... }
# => Frequency::InvalidProbabilityError: unsupported probability type: Symbol
```

## Development

```sh
bin/setup           # bundle install
bundle exec rake    # run specs + rubocop
bundle exec rspec   # specs only
```

CI runs against Ruby 3.1, 3.2, 3.3, and 3.4.

## Releasing

This gem publishes to RubyGems via [trusted publishing][tp] — no API tokens
stored as secrets.

**One-time setup** (gem owner only):

1. On <https://rubygems.org/gems/frequency-dsl>, open **Trusted publishers**
   and create one with:
   - Owner: `peczenyj`
   - Repository: `Frequency`
   - Workflow filename: `release.yml`
   - Environment: `release`
2. In this repo's **Settings → Environments**, create an environment named
   `release` (add manual approval if desired).

**To cut a release:**

```sh
# Bump Frequency::VERSION in lib/frequency.rb, then:
git commit -am "Release v0.2.0"
git tag v0.2.0
git push origin master --tags
```

The tag push triggers `.github/workflows/release.yml`, which runs the specs,
builds the gem, and pushes it via OIDC.

[tp]: https://guides.rubygems.org/trusted-publishing/

## License

MIT — see [LICENSE](LICENSE).

Copyright © 2010 Tiago Peczenyj.
