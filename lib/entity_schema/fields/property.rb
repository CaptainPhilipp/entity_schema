# frozen_string_literal: true

require_relative 'abstract'

require_relative 'abstract'

module EntitySchema
  module Fields
    # Simple field with any value
    class Property < Abstract
      def initialize(options)
        @predicate = options.predicate
        super(options)
      end

      def get(obj)
        read(obj)
      end
    end
  end
end
