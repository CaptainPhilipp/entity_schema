# frozen_string_literal: true

module EntitySchema
  module Fields
    class Abstract
      attr_reader :src_key, :name, :predicate_name, :setter_name, :ivar_name

      # TODO: simplify #initialize signature in all ancestors
      # def initialize(name, schema, **params)
      def initialize(name, schema, src_key:, private_getter:, private_setter:)
        @name   = name.to_sym
        @schema = schema
        @src_key        = src_key
        @private_getter = private_getter
        @private_setter = private_setter

        @predicate_name = :"#{name}?"
        @setter_name    = :"#{name}="
        @ivar_name      = :"@#{name}"
      end

      def src_keys
        @src_keys ||= [src_key].freeze
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

      attr_reader :schema, :serialize_method

      def raise_public_set
        raise NameError, "Private Setter called for field `#{name}` in `#{schema.owner}`"
      end

      def raise_public_get
        raise NameError, "Private Getter called for field `#{name}` in `#{schema.owner}`"
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
