# frozen_string_literal: true

require_relative 'abstract'

require_relative 'abstract'

module EntitySchema
  module Fields
    # TODO: doc
    class Property < Abstract
      def initialize(options)
        @predicate = options.delete(:predicate)
        super(options)
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
