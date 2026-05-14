# frozen_string_literal: true

require "spec_helper"

RSpec.describe Frequency do
  # Fixed RNG that returns a controllable value; replaces the old
  # Kernel.should_receive(:rand) pattern.
  let(:rng) { instance_double(Random) }

  before { Frequency.random = rng }
  after  { Frequency.random = nil }

  describe ".always" do
    it "runs the block and returns its value" do
      expect(described_class.always { :ok }).to eq(:ok)
    end

    it "returns nil if no block is given" do
      expect(described_class.always).to be_nil
    end
  end

  describe ".never" do
    it "does not run the block" do
      ran = false
      described_class.never { ran = true }
      expect(ran).to be(false)
    end

    it "returns nil" do
      expect(described_class.never { :ok }).to be_nil
    end
  end

  describe ".rarely" do
    it "runs the block when rand is below 0.25" do
      allow(rng).to receive(:rand).and_return(0.24999)
      expect(described_class.rarely { :ran }).to eq(:ran)
    end

    it "skips the block when rand is at or above 0.25" do
      allow(rng).to receive(:rand).and_return(0.25)
      expect(described_class.rarely { :ran }).to be_nil
    end
  end

  describe ".sometimes" do
    it "runs at the default 0.50 threshold" do
      allow(rng).to receive(:rand).and_return(0.49999)
      expect(described_class.sometimes { :ran }).to eq(:ran)
    end

    it "skips at or above the default threshold" do
      allow(rng).to receive(:rand).and_return(0.5)
      expect(described_class.sometimes { :ran }).to be_nil
    end

    it "accepts a Float probability" do
      allow(rng).to receive(:rand).and_return(0.14999)
      expect(described_class.sometimes(with_probability: 0.15) { :ran }).to eq(:ran)
    end

    it "accepts a percent string" do
      allow(rng).to receive(:rand).and_return(0.149999)
      expect(described_class.sometimes(with_probability: "15%") { :ran }).to eq(:ran)
    end

    it "accepts a plain numeric string" do
      allow(rng).to receive(:rand).and_return(0.09)
      expect(described_class.sometimes(with_probability: "0.1") { :ran }).to eq(:ran)
    end

    it "rejects probabilities above 1.0" do
      expect {
        described_class.sometimes(with_probability: "101%") { :ran }
      }.to raise_error(Frequency::InvalidProbabilityError)
    end

    it "rejects negative probabilities" do
      expect {
        described_class.sometimes(with_probability: -0.1) { :ran }
      }.to raise_error(Frequency::InvalidProbabilityError)
    end

    it "rejects malformed strings (regex must anchor properly)" do
      expect {
        described_class.sometimes(with_probability: "50x5%") { :ran }
      }.to raise_error(Frequency::InvalidProbabilityError)
    end

    it "rejects unsupported types" do
      expect {
        described_class.sometimes(with_probability: :half) { :ran }
      }.to raise_error(Frequency::InvalidProbabilityError)
    end
  end

  describe ".normally" do
    it "runs below 0.75" do
      allow(rng).to receive(:rand).and_return(0.74999)
      expect(described_class.normally { :ran }).to eq(:ran)
    end

    it "skips at or above 0.75" do
      allow(rng).to receive(:rand).and_return(0.75)
      expect(described_class.normally { :ran }).to be_nil
    end
  end

  describe ".maybe (alias of .sometimes)" do
    it "behaves like sometimes" do
      allow(rng).to receive(:rand).and_return(0.99)
      expect(described_class.maybe { :ran }).to be_nil
    end
  end

  describe ".with_seed" do
    before { Frequency.random = nil } # don't use the instance_double here

    it "produces deterministic results for a given seed" do
      first  = described_class.with_seed(42) { Array.new(20) { described_class.sometimes { 1 } } }
      second = described_class.with_seed(42) { Array.new(20) { described_class.sometimes { 1 } } }
      expect(first).to eq(second)
    end

    it "restores the previous RNG after the block" do
      previous = Frequency.random
      described_class.with_seed(42) { }
      expect(Frequency.random).to be(previous)
    end
  end

  context "when included as a mixin" do
    let(:host) do
      Class.new do
        include Frequency
      end.new
    end

    it "exposes sometimes on instances" do
      allow(rng).to receive(:rand).and_return(0.1)
      expect(host.sometimes { :ran }).to eq(:ran)
    end

    it "exposes always on instances" do
      expect(host.always { :ok }).to eq(:ok)
    end
  end
end
