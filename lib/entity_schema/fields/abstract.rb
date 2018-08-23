# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Abstract
      attr_reader :src_key, :name, :predicate_name, :setter_name, :ivar_name

      def initialize(specification)
        @name       ||= specification.name
        @owner_name   = specification.owner_name
        @src_key    ||= specification.src_key

        @public_getter = specification.public_getter # TODO: rm
        @public_setter = specification.public_setter # TODO: rm

        @ivar_name = :"@#{@name}"
      end

      # set from public caller
      def public_set(obj, value)
        raise_public_set unless @public_setter
        set(obj, value)
      end

      def public_get(obj)
        raise_public_get unless @public_getter
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

      def serialize(obj, output)
        output[src_key] = read(obj) if given?(obj)
      end

      private

      attr_reader :owner_name, :serialize_method

      def raise_public_set
        raise NameError, "Private Setter called for field `#{name}` of `#{owner_name}`"
      end

      def raise_public_get
        raise NameError, "Private Getter called for field `#{name}` of `#{owner_name}`"
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
