# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # TODO: doc
    class Predicate < Base
      def base_set(storage, value)
        case value
        when true, false then write(storage, value)
        when nil         then write(storage, false)
        else                  write(storage, true)
        end
      end

      def base_get(storage)
        storage[src_key] ? true : false
      end
    end
  end
end
