# frozen_string_literal: true

require_relative 'base'
require_relative '../property'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Property < Base
        private

        def create_field_params(name, _owner, o)
          super.merge!(
            predicate: o[:predicate]
          )
        end

        def field_klass
          Fields::Property
        end
      end
    end
  end
end
