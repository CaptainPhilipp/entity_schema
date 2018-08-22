# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    # TODO: doc
    class Object < Abstract
      def initialize(name, schema, options)
        @mapper     = options.delete(:mapper)
        @serializer = options.delete(:serializer)
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
        output[src_key] = unwrap(value)
      end

      private

      attr_reader :mapper, :serializer

      def map(hash)
        mapper.call(hash)
      end

      def unwrap(object)
        serializer.call(object)
      end
    end
  end
end
