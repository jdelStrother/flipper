# Simple class for turning a flipper_id into an actor that can be based
# to Flipper::Feature#enabled?.
module Flipper
  class Actor
    attr_reader :flipper_id, :flipper_attributes

    def initialize(flipper_id, flipper_attributes = {})
      @flipper_id = flipper_id
      @flipper_attributes = flipper_attributes
    end

    def eql?(other)
      self.class.eql?(other.class) && @flipper_id == other.flipper_id
    end
    alias_method :==, :eql?
  end
end
