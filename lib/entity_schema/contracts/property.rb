# frozen_string_literal: true

require_relative 'common'

module EntitySchema
  module Contracts
    Property = Common + [
      predicate: { eq: [true, false, nil] }
    ]
  end
end
