# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # TODO: doc
    class Property < Abstract
      def base_set(storage, value)
        write(storage, value)
      end

      def base_get(storage, value)
        read(storage, value)
      end
    end
  end
end
