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
        when Hash
          new(args)
        when Symbol, String
          new(args)
        end
      end

      attr_reader :left, :operator, :right

      def initialize(value)
        raise ArgumentError, 'value cannot be nil' if value.nil?
        raise ArgumentError, 'value must be Array' unless value.is_a?(Array)
        raise ArgumentError, 'value must have 3 items' unless value.size == 3

        operator = value[1]
        @left = evaluate("left".freeze, value[0])
        @operator = evaluate("operater".freeze, value[1])
        # TODO: Enforce operator being operator but allow String or Symbol version too
        raise ArgumentError unless @operator.is_a?(Flipper::Types::Operator)
        @right = evaluate("right".freeze, value[2])
      end

      def value
        [@left.value, @operator.value, @right.value]
      end

      # TODO: Support left or right being a Flipper::Types::Comparison
      def match?(attributes)
        left_value = case @left
        when Flipper::Types::Property
          attributes[@left.typecast_value]
        else
          @left.typecast_value
        end

        right_value = case @right
        when Flipper::Types::Property
          attributes[@right.typecast_value]
        else
          @right.typecast_value
        end

        !! case @operator.typecast_value
        when "or"
          @left.match?(attributes) || @right.match?(attributes)
        when "and"
          @left.match?(attributes) && @right.match?(attributes)
        when "eq"
          left_value == right_value
        when "neq"
          left_value && left_value != right_value
        when "gt"
          left_value && left_value > right_value
        when "gte"
          left_value && left_value >= right_value
        when "lt"
          left_value && left_value < right_value
        when "lte"
          left_value && left_value <= right_value
        when "in"
          right_value.include?(left_value)
        when "nin"
          !right_value.include?(left_value)
        else
          raise OperatorNotFound.new(@operator)
        end
      end

      private

      def evaluate(name, value)
        case value
        when Hash
          Flipper::Type.from_hash(value)
        when Array
          Flipper::Types::Comparison.new(value)
        when Symbol
          Flipper::Types::String.new(value)
        when String
          Flipper::Types::String.new(value)
        when Integer
          Flipper::Types::Integer.new(value)
        else
          raise "unsupported type for #{name} #{value.inspect} #{value.class}"
        end
      end
    end
  end
end
