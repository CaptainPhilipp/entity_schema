# frozen_string_literal: true

require 'dry/core/class_builder'

module EntitySchema
  # TODO: doc
  module EntityMixin
    attr_reader :attributes

    def initialize(params)
      self.class.finalize!
      @attributes = self.class.schema.slice(params)
    end

    def [](key)
      self.class.schema.public_get(attributes, key)
    end

    def fetch(key, default = Undefined)
      self.class.schema.public_get(attributes, key, default: default)
    end

    def []=(key, value)
      self.class.schema.public_set(attributes, key, value)
    end

    def key?(key)
      self.class.schema.key?(key)
    end
  end
end
