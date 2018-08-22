# frozen_string_literal: true

require_relative 'base'
require_relative '../object'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Object < Base
        private

        def field_klass
          Fields::Object
        end
      end
    end
  end
end
