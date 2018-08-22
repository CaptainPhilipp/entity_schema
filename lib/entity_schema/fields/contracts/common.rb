# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    module Contracts
      # TODO: doc
      # TODO: refactor overweight class
      # Builder is a Functional Object for creating Field using given options
      # In Abstract class defined interface and methods for processing any given options
      class Common < Abstract
        def contract
          super.merge!(
            key:     { eq: nil, type: Symbol },
            getter:  { eq: [:private, nil] },
            setter:  { eq: [:private, nil] },
            private: { eq: [true, false, :getter, :setter, nil] }
          )
        end
      end
    end
  end
end
