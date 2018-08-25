# frozen_string_literal: true

require_relative 'abstract'

require_relative 'abstract'

module EntitySchema
  module Fields
    # Simple field with any value
    class Property < Abstract
      def initialize(options)
        super(options)
        specification.predicate = options[:predicate]
      end

      def get(obj)
        read(obj)
      end
    end
  end
end
