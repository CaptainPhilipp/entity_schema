# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
    # TODO: doc
    class Object < Abstract
      def initialize(name, schema, src_key:, private_getter:, private_setter:, map_to:, map_method:, serialize_method:)
        @map_to     = map_to
        @map_method = map_method
        super(name, schema, src_key: src_key, private_getter: private_getter, private_setter: private_setter)
      end

      # mapped tuple must be only in `objects` hash
      def private_set(attributes, objects, value)
        case value
        when map_to
          delete(attributes)
          write(objects, value)
        when Hash
          delete(objects)
          write(attributes, value)
        else raise ArumentError, "Value (#{value}) should be `#{map_to}` or `Hash`"
        end
      end

      # mapped tuple must be only in `objects` hash
      # prioritized operation - read once. in this case #delete will be called each time
      def private_get(attributes, objects)
        tuple = delete(attributes)
        tuple.nil? ? read(objects) : write(objects, map(tuple))
      end

      def serialize(output, objects)
        write(output, read(objects).public_send(serialize_method))
      end

      private

      attr_reader :map_to, :map_method, :serialize_method

      def map(tuple)
        map_to.public_send(map_method, tuple)
      end

      def delete(attributes)
        attributes.delete(src_key)
      end
    end
  end
end
