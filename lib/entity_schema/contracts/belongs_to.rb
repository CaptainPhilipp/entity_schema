# frozen_string_literal: true

require_relative 'fk_belongs_to'
require_relative 'object_belongs_to'

module EntitySchema
  module Contracts
    BelongsTo = FkBelongsTo + ObjectBelongsTo + [
      fk: { eq: [nil], type: Symbol },
      pk: { eq: [nil], type: Symbol }
    ]
  end
end
