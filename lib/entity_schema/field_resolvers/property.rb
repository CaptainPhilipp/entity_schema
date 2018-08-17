# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module FieldResolvers
    # TODO: doc
    class Property < Abstract
      def initialize(name, schema, src_key:, private_getter:, private_setter:, predicate:)
        @predicate = :predicate
        super(name, schema, src_key: src_key, private_getter: private_getter, private_setter: private_setter)
      end

      def predicate?
        @predicate
      end

      def private_set(attributes, _objects, value)
        write(attributes, value)
      end

      def private_get(attributes, _objects)
        read(attributes)
      end
    end
  end
end
