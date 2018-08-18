# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Collection < Object
      # mapped tuple must be only in `objects` hash
      def private_set(attributes, objects, values)
        value = values.first
        case value
        when map_to
          delete(attributes)
          write(objects, values)
        when Hash
          delete(objects)
          write(attributes, values)
        else raise ArumentError, "Value (#{value}) should be `#{map_to}` or `Hash`"
        end
      end

      # ? what if entity initialized with object, not with tuple? is it invalid, or we must wrap or analize input?
      def private_get(attributes, objects)
        tuple = delete(attributes)
        tuple.nil? ? read(objects) : write(objects, map(tuple))
      end

      def serialize(output, objects)
        write(output, read(objects).map { |obj| obj.public_send(serialize_method) })
      end

      private

      attr_reader :serialize_method

      def map(tuples)
        tuples.map { |tuple| map_to.public_send(map_method, tuple) }
      end
    end
  end
end
