# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # Abstract resolver
    class Abstract
      def initialize(name, schema, **opts)
        @schema     =   schema
        @name       =   name.to_sym
        @src_key    =   opts.delete(:key)&.to_sym || @name
        is_private  =  !opts.delete(:private)
        @public_set = !!opts.delete(:setter) || !is_private
        @public_get = !!opts.delete(:getter) || !is_private
        @nil_filler =   opts.delete(:nil_filler)
        raise "Unknown options given: #{opts.inspect}" if opts.any?
      end

      def public_set(storage, value)
        return base_set(storage, value) if public_set?
        raise_disabled(subject: 'Setter')
      end

      def public_get(storage, default: Undefined)
        return base_get(storage) if public_get?
        return default if default != Undefined
        raise_disabled(subject: 'Getter')
      end

      def public_set?
        @public_set
      end

      def public_get?
        @public_get
      end

      def base_set(storage, value)
        raise NotImplementedError
      end

      def base_get(storage)
        raise NotImplementedError
      end

      private

      attr_reader :schema, :name, :src_key, :nil_filler

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
