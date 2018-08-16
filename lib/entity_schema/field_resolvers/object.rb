# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
    # TODO: doc
    class Object < Abstract
      # mapped tuple must be only in `objects` hash
      def base_set(attributes, objects, value)
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
      def base_get(attributes, objects)
        tuple = delete(attributes)
        tuple.nil? ? read(objects) : write(objects, map(tuple))
      end

      def serialize(output, objects)
        write(output, read(objects).public_send(serialize_method))
      end

      private

      attr_reader :serialize_method

      def map(tuple)
        map_to.public_send(map_method, tuple)
      end

      def delete(attributes)
        attributes.delete(src_key)
      end
    end
  end
end
