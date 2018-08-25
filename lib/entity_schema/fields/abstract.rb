# frozen_string_literal: true

module EntitySchema
  module Fields
    # Specification for fiend behaviour: internal and external
    #   will be used for build Field object and for setup Field object
    class Abstract
      Specification = Struct.new(:public_getter, :public_setter, :predicate)

      attr_reader :src_key, :name, :specification

      def initialize(options)
        @name       ||= options[:name]
        @owner_name   = options[:owner_name]
        @src_key    ||= options[:src_key]
        @ivar_name = :"@#{name}"

        @specification = Specification.new
        @specification.public_getter = options[:public_getter]
        @specification.public_setter = options[:public_setter]
      end

      def public_set(obj, value)
        raise_public('Setter') unless specification.public_setter
        set(obj, value)
      end

      def public_get(obj)
        raise_public('Getter') unless specification.public_getter
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
