# frozen_string_literal: true

require 'dry/core/class_builder'

module EntitySchema
  # TODO: doc
  module EntityMixin
    def initialize(params)
      self.class.finalize!
      @attributes = params.slice(*self.class.schema.names)
      @objects    = {}
    end

    def [](key)
      self.class.schema.get(@attributes, @objects, key)
    end

    def []=(key, value)
      self.class.schema.set(@attributes, @objects, key, value)
    end

    def key?(name)
      self.class.schema.field?(name)
    end

    def to_h
      @attributes.dup.tap do |output|
        self.class.schema.object_fields.each { |f| f.serialize(output, @objects) }
      end
    end
  end
end
