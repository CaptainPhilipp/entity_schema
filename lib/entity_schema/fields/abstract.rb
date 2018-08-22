# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Abstract
      attr_reader :src_key, :name, :predicate_name, :setter_name, :ivar_name

      def initialize(name, owner_name, options)
        @name = name.to_sym
        @owner_name = owner_name
        @src_key       = options.delete(:src_key)
        @public_getter = options.delete(:public_getter)
        @public_setter = options.delete(:public_setter)

        @predicate_name = :"#{name}?"
        @setter_name    = :"#{name}="
        @ivar_name      = :"@#{name}"
      end

      # set from public caller
      def public_set(obj, value)
        raise_public_set unless public_setter?
        set(obj, value)
      end

      def public_get(obj)
        raise_public_get unless public_getter?
        get(obj)
      end

      def given?(obj)
        obj.instance_variable_defined?(ivar_name)
      end

      def delete(obj)
        obj.remove_instance_variable(ivar_name)
      end

      def set(obj, value)
        write(obj, value)
      end

      # :nocov:
      def get(_obj)
        raise NotImplementedError
      end
      # :nocov:

      def predicate?
        false
      end

      def serialize(obj, output)
        output[src_key] = read(obj) if given?(obj)
      end

      def public_getter?
        @public_getter
      end

      def public_setter?
        @public_setter
      end

      private

      attr_reader :owner_name, :serialize_method

      def raise_public_set
        raise NameError, "Private Setter called for field `#{name}` of `#{owner_name}`"
      end

      def raise_public_get
        raise NameError, "Private Getter called for field `#{name}` of `#{owner_name}`"
      end

      def guard_unknown_options!(opts)
        raise "Unknown builder options given: #{opts.inspect}" if opts.any?
      end

      def read(obj)
        obj.instance_variable_get(ivar_name)
      end

      def write(obj, value)
        obj.instance_variable_set(ivar_name, value)
      end
    end
  end
end
