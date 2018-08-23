# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Abstract
      attr_reader :src_key, :name

      def initialize(specification)
        @name       ||= specification.name
        @owner_name   = specification.owner_name
        @src_key    ||= specification.src_key

        @public_getter = specification.public_getter?
        @public_setter = specification.public_setter?

        @ivar_name = :"@#{name}"
      end

      def public_set(obj, value)
        raise_public('Setter') unless @public_setter
        set(obj, value)
      end

      def public_get(obj)
        raise_public('Getter') unless @public_getter
        get(obj)
      end

      def given?(obj)
        obj.instance_variable_defined?(ivar_name)
      end

      def set(obj, value)
        write(obj, value)
      end

      # :nocov:
      def get(_obj)
        raise NotImplementedError
      end
      # :nocov:

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

      attr_reader :ivar_name, :owner_name, :serialize_method

      def raise_public(subject)
        raise NameError, "Private #{subject} called for field `#{name}` of `#{owner_name}`"
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
