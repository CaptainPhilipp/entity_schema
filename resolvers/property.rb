# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # TODO: doc
    class Property < Base
      def base_set(storage, value)
        write(storage, value)
      end
    end
  end
end
