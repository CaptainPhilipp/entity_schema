# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Abstract
      attr_reader :src_key, :name, :predicate_name, :setter_name, :ivar_name

      # TODO: simplify #initialize signature in all ancestors
      # def initialize(name, owner_name, **params)
      def initialize(name, owner_name, options)
        @name = name.to_sym
        @owner_name = owner_name
        @src_key        = options.delete(:src_key)
        @private_getter = options.delete(:private_getter)
        @private_setter = options.delete(:private_setter)

        @predicate_name = :"#{name}?"
        @setter_name    = :"#{name}="
        @ivar_name      = :"@#{name}"
      end

      # set from public caller
      def public_set(obj, value)
        raise_public_set if private_setter?
        set(obj, value)
      end

      def public_get(obj)
        raise_public_get if private_getter?
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

      def get(_obj)
        raise NotImplementedError
      end

      def predicate?
        false
      end

      def serialize(obj, output)
        output[src_key] = read(obj) if given?(obj)
      end

      def private_getter?
        @private_getter
      end

      def private_setter?
        @private_setter
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
        raise "Unknown options given: #{opts.inspect}" if opts.any?
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
