module Flipper
  module Gates
    class Comparison < Gate
      # Internal: The name of the gate. Used for instrumentation, etc.
      def name
        :comparison
      end

      # Internal: Name converted to value safe for adapter.
      def key
        :comparisons
      end

      def data_type
        :comparison
      end

      def enabled?(value)
        !value.empty?
      end

      # Internal: Checks if the gate is open for a thing.
      #
      # Returns true if gate open for thing, false if not.
      def open?(context)
        value = context.values[key]
        if context.thing.nil?
          false
        else
          value.any? do |name|
            comparison = Flipper::Types::Comparison.new(*value)
            comparison.match?(context.thing, context)
          end
        end
      end

      def wrap(thing)
        Types::Comparison.wrap(thing)
      end

      def protects?(thing)
        thing.is_a?(Types::Comparison) || (thing.is_a?(Array) && thing.size == 3)
      end
    end
  end
end
