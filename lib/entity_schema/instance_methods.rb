# frozen_string_literal: true

module EntitySchema
  # TODO: doc
  module InstanceMethods
    def initialize(params = Undefined)
      self.class.finalize!
      # TODO: slice by ruby version
      @attributes_ = (params == Undefined ? {} : params.slice(*self.class.schema.names))
      @objects_ = {}
    end

    def update_attributes(params)
      params.each_pair do |attr, value|
        next unless key?(attr)
        set(attr, value)
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
      self.class.schema.given?(@attributes_, @objects, name)
    end

    def to_h
      @attributes_.dup.tap do |output|
        @objects_.each_key do |key|
          self.class.schema.object_fields[key].serialize(output, @objects_)
        end
      end
    end
  end
end
