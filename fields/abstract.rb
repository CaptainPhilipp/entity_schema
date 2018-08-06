# frozen_string_literal: true

module EntitySchema
  module Fields
    # Abstract field
    class Abstract
      def initialize(name, schema, **opts)
        @schema = schema
        @name   = name.to_sym
        configure(opts)
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

      private

      attr_reader :schema, :name, :src_key, :nil_filler, :serialize_method

      def configure(opts)
        @src_key    =   opts.delete(:key)&.to_sym || @name
        is_private  =  !opts.delete(:private)
        @public_set = !!opts.delete(:setter) || !is_private
        @public_get = !!opts.delete(:getter) || !is_private
        @nil_filler =   opts.delete(:nil_filler)
        @serialize_method = opts.delete(:serialize)
        raise "Unknown options given: #{opts.inspect}" if opts.any?
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

      def exist?(storage)
        storage.key? src_key
      end

      def raise_disabled(subject:)
        raise NoMethodError,
              "#{subject} disabled for property `##{name}` in #{schema.owner}'s schema '#{schema.full_name}'"
      end
    end
  end
end
