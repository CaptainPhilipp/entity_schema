# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
    # Abstract field
    class Abstract
      attr_reader :src_key, :name # TODO: :name private?

      # def initialize(name, schema, **params)
      def initialize(name, schema, src_key:, private_getter:, private_setter:)
        @name   = name.to_sym
        @schema = schema
        @src_key        = src_key
        @private_getter = private_getter
        @private_setter = private_setter
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

      def private_getter?
        @private_getter
      end

      def private_setter?
        @private_setter
      end

      def given?(*storages)
        storages.all? { |storage| storage.key? src_key }
      end

      private

      attr_reader :schema, :serialize_method

      def bool(value)
        value ? true : false
      end

      def guard_public_set
        raise_private(subject: 'Setter') if private_setter?
      end

      def guard_public_get
        raise_private(subject: 'Getter') if private_getter?
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

      def raise_private(subject:)
        raise NameError, "Private #{subject} called for field `#{name}` in `#{schema.owner}`"
      end
    end
  end
end
