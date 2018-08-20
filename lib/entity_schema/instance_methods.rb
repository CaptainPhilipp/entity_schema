# frozen_string_literal: true

module EntitySchema
  # TODO: doc
  module InstanceMethods
    def initialize(params = EMPTY_HASH)
      update_attributes(params)
    end

    # TODO: spec
    def update_attributes(params)
      self.class.entity_schema.set_from_params(self, params)
    end

    def set(name, value)
      self.class.entity_schema.public_set(self, name, value)
    end

    alias []= set

    def get(name)
      self.class.entity_schema.public_get(self, name)
    end

    alias [] get

    def field?(name)
      self.class.entity_schema.field?(name)
    end

    def given?(name)
      self.class.entity_schema.given?(self, name)
    end

    def key?(name)
      self.class.entity_schema.weak_given?(self, name)
    end

    def to_h
      self.class.entity_schema.serialize(self)
    end
  end
end
