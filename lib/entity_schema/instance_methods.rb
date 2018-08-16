# frozen_string_literal: true

module EntitySchema
  # TODO: doc
  module InstanceMethods
    def initialize(params = Undefined)
      self.class.finalize!
      # TODO: change slice for ruby < 2.5.0
      @attributes_ = (params == Undefined ? {} : params.slice(*self.class.schema.src_keys))
      @objects_ = {}
    end

    def update_attributes(params)
      params.each_pair do |attr, value|
        self.class.schema.weak_set(@attributes_, @objects_, key, value)
      end
    end

    def get(key)
      self.class.schema.get(@attributes_, @objects_, key)
    end

    alias [] get

    def set(key, value)
      self.class.schema.set(@attributes_, @objects_, key, value)
    end

    alias []= set

    def field?(name)
      self.class.schema.field?(name)
    end

    def given?(name)
      self.class.schema.given?(@attributes_, @objects_, name)
    end

    def key?(name)
      self.class.schema.weak_given?(@attributes_, @objects_, name)
    end

    def to_h
      self.class.schema.serialize(@attributes_, @objects_)
    end
  end
end
