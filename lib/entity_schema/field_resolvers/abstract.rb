# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
    # Abstract field
    class Abstract
      attr_reader :src_key, :name

      # TODO: simplify #initialize signature in all ancestors
      # def initialize(name, schema, **params)
      def initialize(name, schema, src_key:, private_getter:, private_setter:)
        @name   = name.to_sym
        @schema = schema
        @src_key        = src_key
        @private_getter = private_getter
        @private_setter = private_setter
      end

      def public_set(attributes, objects, value)
        raise_public_set if private_setter?
        private_set(attributes, objects, value)
      end

      def public_get(attributes, objects)
        raise_public_get if private_getter?
        private_get(attributes, objects)
      end

      def weak_set(attributes, objects, value)
        return if private_setter?
        private_get(attributes, objects)
      end

      def remove(attributes, objects)
        delete(attributes) || delete(objects)
      end

      def private_set(_attributes, _objects, _value)
        raise NotImplementedError
      end

      def private_get(_attributes, _objects)
        raise NotImplementedError
      end

      def private_getter?
        @private_getter
      end

      def private_setter?
        @private_setter
      end

      def given?(attributes, objects)
        attributes.key?(src_key) || objects.key?(src_key)
      end

      def predicate?
        false
      end

      private

      attr_reader :schema, :serialize_method

      def raise_public_set
        raise NameError, "Private Setter called for field `#{name}` in `#{schema.owner}`"
      end

      def raise_public_get
        raise NameError, "Private Getter called for field `#{name}` in `#{schema.owner}`"
      end

      def read(storage)
        storage[src_key]
      end

      def write(storage, value)
        storage[src_key] = value
      end

      def delete(attributes)
        attributes.delete(src_key)
      end
    end
  end
end
