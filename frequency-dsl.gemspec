# frozen_string_literal: true

require_relative "lib/frequency"

Gem::Specification.new do |spec|
  spec.name = "frequency-dsl"
  spec.version = Frequency::VERSION
  spec.authors = ["Tiago Peczenyj"]
  spec.email = ["tiago.peczenyj@gmail.com"]

  spec.summary = "A small DSL for probabilistic event execution"
  spec.description = "Frequency is a small DSL written in Ruby to work with " \
                     "frequency events (never, sometimes, always, ...)."
  spec.homepage = "https://github.com/peczenyj/Frequency"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir[
    "lib/**/*.rb",
    "LICENSE",
    "README.md",
    "CHANGELOG.md",
    "VERSION"
  ]
  spec.require_paths = ["lib"]
end
