require 'flipper/typecast'

module Flipper
  module Types
    class String < Type
      attr_reader :typecast_value

      def initialize(value)
        @typecast_value = Typecast.to_string(value)
        @value = {
          "type" => "string",
          "value" => @typecast_value,
        }
      end
    end
  end
end
