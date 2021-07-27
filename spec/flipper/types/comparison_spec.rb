require 'helper'
require 'flipper/types/comparison'

RSpec.describe Flipper::Types::Comparison do
  describe ".wrap" do
    context "with a comparison" do
      it "returns comparison" do
        instance = described_class.new(["plan", "eq", "basic"])
        comparison = described_class.wrap(instance)
        expect(comparison.left_value).to eq("plan")
        expect(comparison.operator).to eq("eq")
        expect(comparison.right_value).to eq("basic")
      end
    end

    context "with an array" do
      it "returns comparison" do
        comparison = described_class.wrap(["plan", "eq", "basic"])
        expect(comparison.left_value).to eq("plan")
        expect(comparison.operator).to eq("eq")
        expect(comparison.right_value).to eq("basic")
      end
    end

    context "with 3 arguments" do
      it "returns comparison" do
        comparison = described_class.wrap("plan", "eq", "basic")
        expect(comparison.left_value).to eq("plan")
        expect(comparison.operator).to eq("eq")
        expect(comparison.right_value).to eq("basic")
      end
    end
  end

  it "raises error with nil" do
    expect do
      described_class.new(nil)
    end.to raise_error(ArgumentError)
  end

  it "raises error when not array" do
    expect do
      described_class.new("foo")
    end.to raise_error(ArgumentError)
  end

  it "raises error when not array doesn't have 3 items" do
    [
      ["1"],
      ["1", "2"],
      ["1", "2", "3", "4"],
    ].each do |array|
      expect do
        described_class.new(array)
      end.to raise_error(ArgumentError)
    end
  end

  it "initializes with array of strings" do
    comparison = described_class.new(["plan", "eq", "basic"])
    expect(comparison.left_value).to eq("plan")
    expect(comparison.operator).to eq("eq")
    expect(comparison.right_value).to eq("basic")
  end

  it "initializes with array of symbols" do
    comparison = described_class.new([:plan, :eq, :basic])
    expect(comparison.left_value).to eq("plan")
    expect(comparison.operator).to eq("eq")
    expect(comparison.right_value).to eq("basic")
  end
end
