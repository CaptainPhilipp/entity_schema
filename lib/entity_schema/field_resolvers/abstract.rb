# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
    # Abstract field
    class Abstract
      attr_reader :name

      # def initialize(name, schema, **params)
      def initialize(name, schema, src_key:, private_getter:, private_setter:, get_enabled:, set_enabled:)
        @name   = name.to_sym
        @schema = schema
        @src_key        = src_key
        @private_getter = private_getter
        @private_setter = private_setter
        @get_enabled    = get_enabled
        @set_enabled    = set_enabled
      end

      def public_set(attributes, objects, value)
        guard_public_set
        base_set(attributes, objects, value)
      end

      def public_get(attributes, objects)
        guard_public_get
        base_get(attributes, objects)
      end

      def base_set(_attributes, _objects, _value)
        raise NotImplementedError
      end

      def base_get(_attributes, _objects)
        raise NotImplementedError
      end

      def get_enabled?
        @get_enabled
      end

      def set_enabled?
        @set_enabled
      end

      def private_getter?
        @is_private_getter
      end

      def private_setter?
        @is_private_setter
      end

      def given?(*storages)
        storages.all? { |storage| storage.key? src_key }
      end

      private

      attr_reader :schema, :src_key, :serialize_method

      def to_bool(value)
        value ? true : false
      end

      def guard_public_set
        raise_disabled(subject: 'Setter') unless set_enabled?
      end

      def guard_public_get
        raise_disabled(subject: 'Getter') unless get_enabled?
      end

      def read(storage)
        storage[src_key]
      end

      def write(storage, value)
        storage[src_key] = value
      end

      def raise_disabled(subject:)
        raise NoMethodError, "#{subject} disabled for field `#{name}` in `#{schema.owner}`"
      end
    end
  end
end