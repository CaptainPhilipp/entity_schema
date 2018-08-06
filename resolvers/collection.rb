# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # TODO: doc
    class Collection < Abstract
      def base_set(storage, values)
        # TODO: wrap to collection proxy
        raise NotImplementedError
      end

      def base_get(storage)
        # TODO: wrap to collection proxy
        raise NotImplementedError
      end
    end
  end
end
