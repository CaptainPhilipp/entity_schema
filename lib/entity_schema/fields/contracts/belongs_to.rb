# frozen_string_literal: true

require_relative 'fk_belongs_to'
require_relative 'object_belongs_to'

module EntitySchema
  module Fields
    module Contracts
      # TODO: doc
      class BelongsTo < Abstract
        def contract
          @contract ||= subcontracts.merge!(
            fk: { eq: nil, type: Symbol },
            pk: { eq: nil, type: Symbol }
          )
        end

        private

        def subcontracts
          FkBelongsTo.contract.merge(ObjectBelongsTo.contract)
        end
      end
    end
  end
end
