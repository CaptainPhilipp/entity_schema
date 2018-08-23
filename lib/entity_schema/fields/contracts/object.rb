# frozen_string_literal: true

require_relative 'common'

module EntitySchema
  module Fields
    module Contracts
      Object = Common + {
        mapper:     { type: Symbol, eq: nil, respond_to: :call },
        map_to:     { type: Class,  eq: nil },
        map_method: { type: Symbol, eq: nil },
        serializer: { type: Symbol, eq: nil, respond_to: :call },
        serialize:  { type: Symbol, eq: nil }
      }
    end
  end
end
