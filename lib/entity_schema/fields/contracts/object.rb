# frozen_string_literal: true

require_relative 'common'
require_relative '../object'

module EntitySchema
  module Fields
    module Contracts
      # TODO: doc
      class Object < Common
        def contract
          super.merge!(
            mapper:     { type: Symbol, eq: nil, respond_to: :call },
            map_to:     { type: Class,  eq: nil },
            map_method: { type: Symbol, eq: nil },
            serializer: { type: Symbol, eq: nil, respond_to: :call },
            serialize:  { type: Symbol, eq: nil }
          )
        end
      end
    end
  end
end
