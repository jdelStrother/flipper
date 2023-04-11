# lib/key_value_store.rb

module Flipper
  module KeyValueStore
    def self.included(base)
      base.extend(ClassMethods)
    end

    Version = 'v1'.freeze
    Namespace = "flipper/#{Version}".freeze
    FeaturesKey = "#{Namespace}/features".freeze
    GetAllKey = "#{Namespace}/get_all".freeze

    module ClassMethods
      # Private
      def key_for(key)
        "#{Namespace}/feature/#{key}"
      end
    end

    protected

    def key_for(key)
      self.class.key_for(key)
    end
  end
end
