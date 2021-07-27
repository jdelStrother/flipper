module Flipper
  module Types
    class Comparison < Type

      attr_reader :left_value, :operator, :right_value

      def initialize(value)
        raise ArgumentError, 'value cannot be nil' if value.nil?
        raise ArgumentError, 'value must be Array' unless value.is_a?(Array)
        raise ArgumentError, 'value must have 3 items' unless value.size == 3

        @value = value.map(&:to_s)
        @left_value, @operator, @right_value = @value
      end
    end
  end
end
