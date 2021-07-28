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

      attr_reader :left, :operator, :right

      def initialize(value)
        raise ArgumentError, 'value cannot be nil' if value.nil?
        raise ArgumentError, 'value must be Array' unless value.is_a?(Array)
        raise ArgumentError, 'value must have 3 items' unless value.size == 3

        @value = value
        @left, @operator, @right = @value
      end

      def match?(attributes)
        property_value = attributes[@left]

        !! case @operator
        when "eq"
          property_value == @right
        when "neq"
          property_value && property_value != @right
        when "gt"
          property_value && property_value > @right
        when "gte"
          property_value && property_value >= @right
        when "lt"
          property_value && property_value < @right
        when "lte"
          property_value && property_value <= @right
        when "in"
          @right.include?(property_value)
        when "nin"
          !@right.include?(property_value)
        when "include"
          property_value && property_value.include?(@right)
        when "exclude"
          property_value && !property_value.include?(@right)
        else
          raise OperatorNotFound.new(@operator)
        end
      end
    end
  end
end
