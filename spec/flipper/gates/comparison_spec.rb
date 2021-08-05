require 'helper'

RSpec.describe Flipper::Gates::Comparison do
  let(:feature_name) { :search }
  let(:actor) {
    Flipper::Actor.new("1", {
      "plan" => "basic",
    })
  }

  subject do
    described_class.new
  end

  def context(set)
    Flipper::FeatureCheckContext.new(
      feature_name: feature_name,
      values: Flipper::GateValues.new(comparisons: set),
      thing: Flipper::Types::Actor.new(actor)
    )
  end

  describe '#enabled?' do
    context 'for true set with items' do
      it 'returns true' do
        expect(subject.enabled?(Set[1, 2, 3])).to eq(true)
      end
    end

    context 'for false empty set' do
      it 'returns false' do
        expect(subject.enabled?(Set.new)).to eq(false)
      end
    end
  end

  describe '#open?' do
    context 'for single comparison that does match actor' do
      it 'returns true' do
        comparisons = Set[
          [
            {"type" => "property", "value" => "plan"},
            {"type" => "operator", "value" => "eq"},
            {"type" => "string", "value" => "basic"},
          ]
        ]
        expect(subject.open?(context(comparisons))).to be(true)
      end
    end

    context 'for single comparison that does NOT match actor' do
      it 'returns false' do
        comparisons = Set[
          [
            {"type" => "property", "value" => "plan"},
            {"type" => "operator", "value" => "eq"},
            {"type" => "string", "value" => "premium"},
          ]
        ]
        expect(subject.open?(context(comparisons))).to be(false)
      end
    end

    context 'for multiple comparisons that do match actor' do
      it 'returns true'
    end

    context 'for multiple comparisons that do NOT match actor' do
      it 'returns false'
    end

    context 'for nested comparisons that do match actor' do
      it 'returns true'
    end

    context 'for nested comparisons that do NOT match actor' do
      it 'returns false'
    end
  end

  describe '#protects?' do
    xit 'returns true for boolean type' do
      expect(subject.protects?(Flipper::Types::Boolean.new(true))).to be(true)
    end

    xit 'returns true for true' do
      expect(subject.protects?(true)).to be(true)
    end

    xit 'returns true for false' do
      expect(subject.protects?(false)).to be(true)
    end
  end

  describe '#wrap' do
    xit 'returns boolean type for boolean type' do
      expect(subject.wrap(Flipper::Types::Boolean.new(true)))
        .to be_instance_of(Flipper::Types::Boolean)
    end

    xit 'returns boolean type for true' do
      expect(subject.wrap(true)).to be_instance_of(Flipper::Types::Boolean)
      expect(subject.wrap(true).value).to be(true)
    end

    xit 'returns boolean type for true' do
      expect(subject.wrap(false)).to be_instance_of(Flipper::Types::Boolean)
      expect(subject.wrap(false).value).to be(false)
    end
  end
end
