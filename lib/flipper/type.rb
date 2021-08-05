module Flipper
  # Internal: Root class for all flipper types. You should never need to use this.
  class Type
    def self.wrap(value_or_instance)
      return value_or_instance if value_or_instance.is_a?(self)
      new(value_or_instance)
    end

    attr_reader :value

    def eql?(other)
      self.class.eql?(other.class) && value == other.value
    end
    alias_method :==, :eql?
  end
end

require 'flipper/types/actor'
require 'flipper/types/boolean'
require 'flipper/types/comparison'
require 'flipper/types/group'
require 'flipper/types/integer'
require 'flipper/types/operator'
require 'flipper/types/percentage'
require 'flipper/types/percentage_of_actors'
require 'flipper/types/percentage_of_time'
require 'flipper/types/property'
require 'flipper/types/set'
require 'flipper/types/string'

module Flipper
  class Type
    TYPE_MAP = {
      "property" => Flipper::Types::Property,
      "operator" => Flipper::Types::Operator,
      "string" => Flipper::Types::String,
      "integer" => Flipper::Types::Integer,
      "set" => Flipper::Types::Set,
    }.freeze

    def self.from_hash(hash)
      raise ArgumentError, "Hash expected but was #{hash.inspect}" unless hash.is_a?(Hash)

      if hash.size == 1
        type, value = hash.flatten.to_a
      else
        type = hash[:type] || hash["type".freeze]
        value = hash[:value] || hash["value".freeze]
      end

      raise "hash type key is missing or nil #{hash.inspect}" if type.nil?
      raise "hash value key is missing or nil #{hash.inspect}" if value.nil?

      klass = TYPE_MAP.fetch(type) {
        raise("unsupported flipper type #{type.inspect}")
      }
      klass.new(value)
    end

    def eql?(other)
      other.class == self.class && other.value == value
    end
    alias_method :==, :eql?
  end
end
