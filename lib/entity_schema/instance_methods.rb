# frozen_string_literal: true

module EntitySchema
  # TODO: doc
  module InstanceMethods
    def initialize(params = EMPTY_HASH)
      update_attributes(params)
    end

    def update_attributes(params)
      params.each_pair { |key, value| self.class.schema.set_by_key(self, key, value) }
    end

    def set(name, value)
      self.class.schema.public_set(self, name, value)
    end

    alias []= set

    def get(name)
      self.class.schema.public_get(self, name)
    end

    alias [] get

    def field?(name)
      self.class.schema.field?(name)
    end

    def given?(name)
      self.class.schema.given?(self, name)
    end

    def key?(name)
      self.class.schema.weak_given?(self, name)
    end

    def to_h
      self.class.schema.serialize(self)
    end
  end
end
