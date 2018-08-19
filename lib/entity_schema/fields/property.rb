# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    # TODO: doc
    class Property < Abstract
      def initialize(name, schema, options)
        @predicate = options.delete(:predicate)
        super(name, schema, options)
        guard_unknown_options!(options)
      end

      def predicate?
        @predicate
      end

      def get(obj)
        read(obj)
      end
    end
  end
end
