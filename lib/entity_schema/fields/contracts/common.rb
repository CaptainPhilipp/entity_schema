# frozen_string_literal: true

require_relative 'contract'

module EntitySchema
  module Fields
    module Contracts
      Common = Contract.new(
        key:     { eq: nil, type: Symbol },
        getter:  { eq: [:private, nil] },
        setter:  { eq: [:private, nil] },
        private: { eq: [true, false, :getter, :setter, nil] }
      )
    end
  end
end
