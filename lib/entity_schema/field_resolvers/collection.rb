# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
    # TODO: doc
    class Collection < Object
      # mapped tuple must be only in `objects` hash
      def base_set(attributes, objects, values)
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

      def base_get(attributes, objects)
        tuple = delete(attributes)
        tuple.nil? ? read(objects) : write(objects, map(tuple))
      end

      def serialize(output, objects)
        write(output, read(objects).map { |obj| obj.public_send(serialize_method) })
      end

      private

      attr_reader :serialize_method

      def configure(params)
        @serialize_method = params.delete(:serialize) || :to_h
        super
      end

      def map(tuples)
        tuples.map { |tuple| map_to.public_send(map_method, tuple) }
      end

      def delete(attributes)
        attributes.delete(src_key)
      end
    end
  end
end
