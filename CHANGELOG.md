# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026

### Changed (BREAKING)

- `with_probability` is now a keyword argument: use
  `sometimes(with_probability: 0.1) { ... }` instead of the old
  `sometimes(:with_probability => 0.1) { ... }`. The hash form no longer works.
- Invalid probabilities now raise `Frequency::InvalidProbabilityError`
  (subclass of `Frequency::Error < StandardError`) instead of a bare
  `RuntimeError`.
- Minimum Ruby version is now 3.1.

### Added

- `Frequency.random=` to inject a custom `Random` instance for reproducible runs.
- `Frequency.with_seed(seed) { ... }` to scope a seeded RNG to a block.
- Module-function call style: `Frequency.sometimes { ... }` works without
  `include Frequency`.
- GitHub Actions CI matrix across Ruby 3.1–3.4.
- GitHub Actions release workflow using RubyGems trusted publishing (OIDC).
- RuboCop config and lint job.

### Fixed

- Percent-string regex was using `.` (any char) instead of `\.`, so malformed
  inputs like `"50x5%"` silently parsed. Now properly anchored and validated.
- Probability validation now produces a clear error type and message.

### Removed

- Jeweler dependency and the generated `rdoc/` directory.

## [0.1.x] - 2010

Initial release. See git history.
