# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Collection < Object
      def set(obj, collection)
        raise ArgumentError, 'collection field must be Array' unless collection.is_a?(Array) || collection.nil?
        super
      end

      def get(obj)
        values = read(obj)
        values.first.is_a?(Hash) ? write(obj, map(values)) : values
      end

      def serialize(obj, output)
        values = read(obj)
        output[src_key] = (values.first.is_a?(Hash) ? values : unwrap(values))
      end

      private

      attr_reader :serialize_method

      def map(tuples)
        tuples.map { |tuple| map_to.public_send(map_method, tuple) }
      end

      def unwrap(objects)
        objects.map { |obj| obj.public_send(serialize_method) }
      end
    end
  end
end
