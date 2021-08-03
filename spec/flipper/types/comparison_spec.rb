require 'helper'
require 'flipper/types/comparison'

RSpec.describe Flipper::Types::Comparison do
  describe ".wrap" do
    context "with a comparison" do
      it "returns comparison" do
        instance = described_class.new(["plan", "eq", "basic"])
        comparison = described_class.wrap(instance)
        expect(comparison.left).to eq("plan")
        expect(comparison.operator).to eq("eq")
        expect(comparison.right).to eq("basic")
      end
    end

    context "with an array" do
      it "returns comparison" do
        comparison = described_class.wrap(["plan", "eq", "basic"])
        expect(comparison.left).to eq("plan")
        expect(comparison.operator).to eq("eq")
        expect(comparison.right).to eq("basic")
      end
    end

    context "with 3 arguments" do
      it "returns comparison" do
        comparison = described_class.wrap("plan", "eq", "basic")
        expect(comparison.left).to eq("plan")
        expect(comparison.operator).to eq("eq")
        expect(comparison.right).to eq("basic")
      end
    end
  end

  describe "#initialize" do
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

    it "raises error when array doesn't have 3 items" do
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
      expect(comparison.left).to eq("plan")
      expect(comparison.operator).to eq("eq")
      expect(comparison.right).to eq("basic")
    end

    it "initializes with array of symbols" do
      comparison = described_class.new([:plan, :eq, :basic])
      expect(comparison.left).to eq("plan")
      expect(comparison.operator).to eq("eq")
      expect(comparison.right).to eq("basic")
    end
  end

  describe "#match?" do
    context "with operator that does not exist" do
      it "raises error" do
        comparison = described_class.new(["plan", "nooooope", "basic"])
        expect {
          comparison.match?({"plan" => "basic"})
        }.to raise_error(Flipper::OperatorNotFound)
      end
    end

    context "eq" do
      it "returns true if equal" do
        comparison = described_class.new(["plan", "eq", "basic"])
        expect(comparison.match?({"plan" => "basic"})).to be(true)
      end

      it "returns false if NOT equal" do
        comparison = described_class.new(["plan", "eq", "basic"])
        expect(comparison.match?({"plan" => "premium"})).to be(false)
      end
    end

    context "neq" do
      it "returns true if NOT equal" do
        comparison = described_class.new(["plan", "neq", "basic"])
        expect(comparison.match?({"plan" => "premium"})).to be(true)
      end

      it "returns false if equal" do
        comparison = described_class.new(["plan", "neq", "basic"])
        expect(comparison.match?({"plan" => "basic"})).to be(false)
      end
    end

    context "gt" do
      it "returns true if greater than" do
        comparison = described_class.new(["age", "gt", 30])
        expect(comparison.match?({"age" => 39})).to be(true)
      end

      it "returns false if less than" do
        comparison = described_class.new(["age", "gt", 40])
        expect(comparison.match?({"age" => 39})).to be(false)
      end

      it "returns false if equal" do
        comparison = described_class.new(["age", "gt", 40])
        expect(comparison.match?({"age" => 40})).to be(false)
      end
    end

    context "gte" do
      it "returns true if greater than" do
        comparison = described_class.new(["age", "gte", 30])
        expect(comparison.match?({"age" => 39})).to be(true)
      end

      it "returns true if equal" do
        comparison = described_class.new(["age", "gte", 30])
        expect(comparison.match?({"age" => 30})).to be(true)
      end

      it "returns false if less than" do
        comparison = described_class.new(["age", "gte", 40])
        expect(comparison.match?({"age" => 39})).to be(false)
      end
    end

    context "lt" do
      it "returns true if less than" do
        comparison = described_class.new(["age", "lt", 30])
        expect(comparison.match?({"age" => 29})).to be(true)
      end

      it "returns false if greater than" do
        comparison = described_class.new(["age", "lt", 40])
        expect(comparison.match?({"age" => 41})).to be(false)
      end

      it "returns false if equal" do
        comparison = described_class.new(["age", "lt", 40])
        expect(comparison.match?({"age" => 40})).to be(false)
      end
    end

    context "lte" do
      it "returns true if less than" do
        comparison = described_class.new(["age", "lte", 30])
        expect(comparison.match?({"age" => 29})).to be(true)
      end

      it "returns true if equal" do
        comparison = described_class.new(["age", "lte", 30])
        expect(comparison.match?({"age" => 30})).to be(true)
      end

      it "returns false greater than" do
        comparison = described_class.new(["age", "lte", 40])
        expect(comparison.match?({"age" => 41})).to be(false)
      end
    end

    context "in" do
      it "returns true if in array" do
        comparison = described_class.new(["age", "in", [10, 20, 30]])
        expect(comparison.match?({"age" => 10})).to be(true)
      end

      it "returns false if NOT in array" do
        comparison = described_class.new(["age", "in", [10, 20, 30]])
        expect(comparison.match?({"age" => 111})).to be(false)
      end
    end

    context "nin" do
      it "returns true if NOT in array" do
        comparison = described_class.new(["age", "nin", [10, 20, 30]])
        expect(comparison.match?({"age" => 1})).to be(true)
      end

      it "returns false if in array" do
        comparison = described_class.new(["age", "nin", [10, 20, 30]])
        expect(comparison.match?({"age" => 10})).to be(false)
      end
    end

    context "include" do
      it "returns true if includes item" do
        comparison = described_class.new(["segments", "include", "old"])
        expect(comparison.match?({"segments" => ["old", "wise"]})).to be(true)
      end

      it "returns false if does NOT include item" do
        comparison = described_class.new(["segments", "include", "young"])
        expect(comparison.match?({"segments" => ["old", "wise"]})).to be(false)
      end

      it "returns false if attribute value nil" do
        comparison = described_class.new(["segments", "include", "young"])
        expect(comparison.match?({})).to be(false)
      end
    end

    context "exclude" do
      it "returns true if does NOT include item" do
        comparison = described_class.new(["segments", "exclude", "young"])
        expect(comparison.match?({"segments" => ["old", "wise"]})).to be(true)
      end

      it "returns false if includes item" do
        comparison = described_class.new(["segments", "exclude", "old"])
        expect(comparison.match?({"segments" => ["old", "wise"]})).to be(false)
      end

      it "returns false if attribute value nil" do
        comparison = described_class.new(["segments", "exclude", "old"])
        expect(comparison.match?({})).to be(false)
      end
    end
  end
end
