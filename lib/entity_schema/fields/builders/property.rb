# frozen_string_literal: true

require_relative 'base'
require_relative '../property'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Property < Base
        private

        def field_klass
          Fields::Property
        end
      end
    end
  end
end
