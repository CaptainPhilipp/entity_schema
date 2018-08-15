# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module FieldResolvers
    # TODO: doc
    class Property < Abstract
      def initialize(*args, **opts)
        @predicate = bool(opts.delete(:predicate))
        super
      end

      def predicate?
        @predicate
      end

      def base_set(attributes, _objects, value)
        write(attributes, value)
      end

      def base_get(attributes, _objects)
        read(attributes)
      end
    end
  end
end
