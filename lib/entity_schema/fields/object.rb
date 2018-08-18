# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Object < Abstract
      # TODO: simplify #initialize signature
      def initialize(name, schema, src_key:, private_getter:, private_setter:, map_to:, map_method:, serialize_method:)
        @map_to           = map_to
        @map_method       = map_method
        @serialize_method = serialize_method
        super(name, schema, src_key: src_key, private_getter: private_getter, private_setter: private_setter)
      end

      def get(obj)
        value = read(obj)
        return value unless value.is_a?(Hash)
        write(obj, map(value))
      end

      def serialize(obj, output)
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
