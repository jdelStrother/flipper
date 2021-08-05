require 'flipper/typecast'

module Flipper
  module Types
    class Set < Type
      attr_reader :typecast_value

      def initialize(value)
        @typecast_value = Typecast.to_set(value)
        @value = {
          "type" => "set",
          "value" => @typecast_value,
        }
      end
    end
  end
end
