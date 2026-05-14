# frozen_string_literal: true

# A small DSL to execute blocks with controlled probability.
#
#   require "frequency"
#
#   # Module-function style:
#   Frequency.sometimes { puts "maybe" }
#   Frequency.rarely(with_probability: 0.01) { log_sample(event) }
#   Frequency.normally(with_probability: "24%") { do_thing }
#
#   # Or mixin style:
#   include Frequency
#   sometimes { puts "maybe" }
module Frequency
  VERSION = "0.2.0"

  # Base error class. Catch this to handle any Frequency-raised error.
  Error = Class.new(StandardError)

  # Raised when the probability value is not a number/string in [0, 1].
  InvalidProbabilityError = Class.new(Error)

  DEFAULTS = {
    normally:  0.75,
    sometimes: 0.50,
    rarely:    0.25
  }.freeze

  PERCENT_PATTERN = /\A-?\d+(?:\.\d+)?%\z/

  # Always run the block. Returns the block's value, or nil if no block.
  def always
    yield if block_given?
  end

  # Never run the block. Returns nil. Ignores any arguments/block.
  def never(*)
    nil
  end

  # Run the block ~75% of the time by default.
  def normally(with_probability: DEFAULTS[:normally], &block)
    Frequency.__run(with_probability, &block)
  end

  # Run the block ~50% of the time by default.
  def sometimes(with_probability: DEFAULTS[:sometimes], &block)
    Frequency.__run(with_probability, &block)
  end

  # Alias of #sometimes.
  alias_method :maybe, :sometimes

  # Run the block ~25% of the time by default.
  def rarely(with_probability: DEFAULTS[:rarely], &block)
    Frequency.__run(with_probability, &block)
  end

  # Make every public instance method also a module-level method, so both
  # `include Frequency; sometimes { ... }` and `Frequency.sometimes { ... }`
  # work. Unlike `module_function`, `extend self` keeps the methods public
  # when the module is included as a mixin.
  extend self

  class << self
    # Inject a custom Random instance for reproducible runs.
    #   Frequency.random = Random.new(42)
    attr_writer :random

    def random
      @random ||= Random.new
    end

    # Run a block with a temporarily-seeded RNG, then restore the previous one.
    #   Frequency.with_seed(42) { sometimes { ... } }
    def with_seed(seed)
      previous = @random
      @random = Random.new(seed)
      yield
    ensure
      @random = previous
    end

    # @api private
    def __run(probability, &block)
      return nil unless block

      rate = __coerce(probability)
      unless (0.0..1.0).cover?(rate)
        raise InvalidProbabilityError, "probability must be in [0, 1], got #{rate}"
      end

      block.call if random.rand < rate
    end

    private

    def __coerce(value)
      case value
      when Numeric then value.to_f
      when String  then __parse_string(value)
      else raise InvalidProbabilityError, "unsupported probability type: #{value.class}"
      end
    end

    def __parse_string(str)
      if PERCENT_PATTERN.match?(str)
        Float(str.chomp("%")) / 100.0
      else
        Float(str)
      end
    rescue ArgumentError, TypeError
      raise InvalidProbabilityError, "could not parse probability: #{str.inspect}"
    end
  end
end
