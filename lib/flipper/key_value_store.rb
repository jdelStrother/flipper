# lib/key_value_store.rb

module Flipper
  module KeyValueStore
    Version = 'v1'.freeze
    Namespace = "flipper/#{Version}".freeze

    def self.included(base)
      base.class_eval do
        class << self
          attr_accessor :key_prefix
        end
        self.key_prefix = "#{Namespace}/"
        attr_writer :key_prefix
      end
    end

    def key_prefix
      @key_prefix || self.class.key_prefix
    end

    # Internal: Used by adapters to look up a key for a given feature
    def key_for(feature_name)
      "#{key_prefix}feature/#{feature_name}"
    end

    def features_key
      "#{key_prefix}features"
    end

    def get_all_key
      "#{key_prefix}get_all"
    end
  end
end
