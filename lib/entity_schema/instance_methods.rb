# frozen_string_literal: true

module EntitySchema
  # TODO: doc
  module InstanceMethods
    def initialize(params = Undefined)
      self.class.finalize!
      # TODO: change slice for ruby < 2.5.0
      @raw_attributes_ = (params == Undefined ? {} : params.slice(*self.class.schema.src_keys))
      @mapped_attributes_ = {}
    end

    def update_attributes(params)
      params.each_pair do |attr, value|
        self.class.schema.weak_set(@raw_attributes_, @mapped_attributes_, key, value)
      end
    end

    def get(key)
      self.class.schema.get(@raw_attributes_, @mapped_attributes_, key)
    end

    alias [] get

    def set(key, value)
      self.class.schema.set(@raw_attributes_, @mapped_attributes_, key, value)
    end

    alias []= set

    def field?(name)
      self.class.schema.field?(name)
    end

    def given?(name)
      self.class.schema.given?(@raw_attributes_, @mapped_attributes_, name)
    end

    def key?(name)
      self.class.schema.weak_given?(@raw_attributes_, @mapped_attributes_, name)
    end

    def to_h
      self.class.schema.serialize(@raw_attributes_, @mapped_attributes_)
    end
  end
end
