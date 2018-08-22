# frozen_string_literal: true

require_relative 'common'

module EntitySchema
  module Fields
    module Contracts
      # TODO: doc
      class Property < Common
        def contract
          super.merge!(
            predicate: { eq: [true, false, nil] }
          )
        end
      end
    end
  end
end
