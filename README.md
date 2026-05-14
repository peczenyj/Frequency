# Frequency

[![CI](https://github.com/peczenyj/Frequency/actions/workflows/ci.yml/badge.svg)](https://github.com/peczenyj/Frequency/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/frequency-dsl.svg)](https://rubygems.org/gems/frequency-dsl)

A small Ruby DSL for executing blocks with controlled probability:
`always`, `normally`, `sometimes`, `rarely`, `never`.

Useful for sampled logging, chaos testing, demo data generation, or anywhere
you want a side effect to fire "occasionally" without writing `rand < 0.25`
by hand every time.

```ruby
require "frequency"

Frequency.always    { metrics.flush }
Frequency.normally  { cache.write(key, value) }
Frequency.sometimes { logger.debug(payload) }
Frequency.rarely    { dump_full_state }
Frequency.never     { not_in_production }
```

## Installation

```ruby
# Gemfile
gem "frequency-dsl"
```

```sh
bundle install
# or, standalone:
gem install frequency-dsl
```

Requires Ruby 3.1 or newer.

## Usage

Two call styles are supported — pick whichever fits your code.

### Module-function style

Recommended for libraries and anywhere you want explicit namespacing:

```ruby
require "frequency"

Frequency.sometimes { puts "maybe" }
Frequency.rarely(with_probability: 0.01) { puts "1% of the time" }
Frequency.normally(with_probability: "24%") { puts "string percent" }
```

### Mixin style

Convenient at the script level or inside a host class:

```ruby
require "frequency"

class EventLogger
  include Frequency

  def record(event)
    sometimes { write_to_disk(event) }
    rarely(with_probability: "0.1%") { ship_for_audit(event) }
  end
end
```

### The `with_probability:` keyword

`sometimes`, `normally`, and `rarely` accept an optional `with_probability:`
keyword argument. It overrides the method's default rate. Accepted values:

| Value           | Meaning              |
| --------------- | -------------------- |
| `0.42`          | Float in `[0, 1]`    |
| `"42%"`         | Percent string       |
| `"42.5%"`       | Fractional percent   |
| `"0.42"`        | Numeric string       |

The keyword is ignored by `always` (always runs) and `never` (never runs).

### Defaults

```ruby
Frequency.normally  { ... }   # 75%
Frequency.sometimes { ... }   # 50%
Frequency.rarely    { ... }   # 25%
Frequency.maybe     { ... }   # alias of .sometimes
```

### Reproducible runs

Inject your own RNG:

```ruby
Frequency.random = Random.new(42)
```

Or scope a seed to a single block — the previous RNG is restored afterward,
even if the block raises:

```ruby
Frequency.with_seed(42) do
  10.times { Frequency.sometimes { puts "deterministic" } }
end
```

This is especially useful in tests, where you want `sometimes` to behave
predictably without mocking `Kernel.rand`.

### Errors

Invalid probabilities raise `Frequency::InvalidProbabilityError`
(a subclass of `Frequency::Error < StandardError`):

```ruby
Frequency.sometimes(with_probability: "101%") { ... }
# => Frequency::InvalidProbabilityError: probability must be in [0, 1], got 1.01

Frequency.sometimes(with_probability: "50x5%") { ... }
# => Frequency::InvalidProbabilityError: could not parse probability: "50x5%"

Frequency.sometimes(with_probability: :half) { ... }
# => Frequency::InvalidProbabilityError: unsupported probability type: Symbol
```

## Development

After cloning:

```sh
bin/setup            # bundle install
bundle exec rake     # specs + lint (Standard)
bundle exec rspec    # specs only
bin/console          # IRB with Frequency loaded
```

Continuous integration runs against Ruby 3.1, 3.2, 3.3, and 3.4 on every
push and pull request — see [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

## Releasing

Releases go to RubyGems via [trusted publishing][tp] — no long-lived API
tokens stored as repository secrets. A push of a `v*` tag triggers
[`.github/workflows/release.yml`](.github/workflows/release.yml), which
runs specs, builds the gem, and authenticates to RubyGems via short-lived
OIDC credentials.

**One-time setup** (gem owner only):

1. On <https://rubygems.org/gems/frequency-dsl>, open **Trusted publishers**
   and create one with:
   - Owner: `peczenyj`
   - Repository: `Frequency`
   - Workflow filename: `release.yml`
   - Environment: `release`
2. In this repo, go to **Settings → Environments** and create an environment
   named `release`. Optional but recommended: add a required reviewer so each
   release needs manual approval.

**Cutting a release:**

```sh
# Bump Frequency::VERSION in lib/frequency.rb,
# update CHANGELOG.md (move [Unreleased] entries under the new version),
# then:
git commit -am "Release v0.2.0"
git tag v0.2.0
git push origin master --tags
```

[tp]: https://guides.rubygems.org/trusted-publishing/

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/peczenyj/Frequency).

1. Fork and create a branch
2. Run `bin/setup`
3. Make your change, add specs
4. `bundle exec rake` — both specs and lint must pass
5. Open a PR

## License

Apache License 2.0 — see [LICENSE](LICENSE).

Copyright © 2010–2026 Tiago Peczenyj.
