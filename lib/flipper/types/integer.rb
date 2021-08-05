require 'flipper/typecast'

module Flipper
  module Types
    class Integer < Type
      attr_reader :typecast_value

      def initialize(value)
        @typecast_value = Typecast.to_integer(value)
        @value = {
          "type" => "integer",
          "value" => @typecast_value,
        }
      end
    end
  end
end
