# frozen_string_literal: true

require_relative 'base'

module EntitySchema
  module Fields
    module Specifications
      # TODO: doc
      class Property < Base
        private

        def transform_options(o)
          super.merge!(
            predicate: to_bool(o[:predicate])
          )
        end
      end
    end
  end
end
