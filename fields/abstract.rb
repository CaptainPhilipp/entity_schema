# frozen_string_literal: true

module EntitySchema
  module Fields
    # Abstract field
    class Abstract
      def initialize(name, schema, **params)
        @name   = name.to_sym
        @schema = schema
        configure(params)
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

      def public_set?
        @public_set
      end

      def public_get?
        @public_get
      end

      def given?(*storages)
        storages.all? { |storage| storage.key? src_key }
      end

      private

      attr_reader :schema, :name, :src_key, :serialize_method

      def configure(params)
        private_    = to_bool(params.delete(:private))
        @public_set = to_bool(params.delete(:setter)) || !private_
        @public_get = to_bool(params.delete(:getter)) || !private_
        @src_key    = params.delete(:key)&.to_sym || @name

        raise "Unknown options given: #{params.inspect}" if params.any?
      end

      def to_bool(value)
        value ? true : false
      end

      def guard_public_set
        raise_disabled(subject: 'Setter') unless public_set?
      end

      def guard_public_get
        raise_disabled(subject: 'Getter') unless public_get?
      end

      def read(storage)
        storage[src_key]
      end

      def write(storage, value)
        storage[src_key] = value
      end

      def raise_disabled(subject:)
        raise NoMethodError,
              "#{subject} disabled for property `##{name}` in #{schema.owner}'s schema '#{schema.full_name}'"
      end
    end
  end
end
