# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Object < Abstract
      def initialize(name, schema, options)
        @map_to           = options.delete(:map_to)
        @map_method       = options.delete(:map_method)
        @serialize_method = options.delete(:serialize_method)
        super(name, schema, options)
        guard_unknown_options!(options)
      end

      def get(obj)
        value = read(obj)
        value.is_a?(Hash) ? write(obj, map(value)) : value
      end

      def serialize(obj, output)
        return unless given?(obj)
        value = read(obj)
        return output[src_key] = value if value.is_a?(Hash)
        output[src_key] = value.public_send(serialize_method)
      end

      private

      attr_reader :map_to, :map_method, :serialize_method

      def map(tuple)
        map_to.public_send(map_method, tuple)
      end
    end
  end
end
