# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
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

        @predicate_name = :"#{name}?"
        @setter_name    = :"#{name}="
        @ivar_name      = :"@#{name}"
      end

      def setup_field(klass)
        remove_field(klass)

        field = self

        klass.define_method(name) { field.get(self) }
        klass.send(:private, name) if private_getter? # TODO: rm #send

        if predicate?
          klass.define_method(predicate_name) { field.get(self) }
          klass.send(:private, predicate_name) if private_getter?
        end

        klass.define_method(setter_name) { |value| field.set(self, value) }
        klass.send(:private, setter_name) if private_setter?
      end

      def remove_field(klass)
        klass.remove_method(name)           if klass.method_defined?(name)
        klass.remove_method(predicate_name) if klass.method_defined?(predicate_name)
        klass.remove_method(setter_name)    if klass.method_defined?(setter_name)
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

      private

      attr_reader :schema, :serialize_method, :predicate_name, :setter_name, :ivar_name

      def private_getter?
        @private_getter
      end

      def private_setter?
        @private_setter
      end

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
