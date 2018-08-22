# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    # TODO: doc
    class Collection < Object
      def set(obj, collection)
        return super if collection.is_a?(Array) || collection.nil?
        raise ArgumentError, 'collection field must be Array'
      end

      def get(obj)
        values = read(obj)
        values&.first.is_a?(Hash) ? write(obj, map(values)) : values
      end

      def serialize(obj, output)
        values = read(obj)
        output[src_key] = (values.first.is_a?(Hash) ? values : unwrap(values))
      end

      private

      def map(hashes)
        hashes.map { |hash| super(hash) }
      end

      def unwrap(objects)
        objects.map { |object| super(object) }
      end
    end
  end
end
