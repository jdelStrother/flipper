module Flipper
  module Types
    class Comparison < Type

      # Given args it builds a comparison instance or raises an error that it can't.
      #
      # Examples:
      #   Flipper::Types::Comparison.wrap(Flipper::Types::Comparison.new("plan", "eq", "basic"))
      #   Flipper::Types::Comparison.wrap(["plan", "eq", "basic"])
      #   Flipper::Types::Comparison.wrap("plan", "eq", "basic")
      #
      # Returns Flipper::Types::Comparison instance or raises exception.
      def self.wrap(*args)
        case args[0]
        when Flipper::Types::Comparison
          args[0]
        when Array
          new(args[0])
        when Symbol, String
          new(args)
        end
      end

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
