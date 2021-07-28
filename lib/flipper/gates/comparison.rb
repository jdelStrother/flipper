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
        rows = context.values[key]
        if context.thing.nil?
          false
        else
          attributes = context.thing.flipper_attributes
          rows.any? do |row|
            comparison = Flipper::Types::Comparison.new(row)
            comparison.match?(attributes)
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
