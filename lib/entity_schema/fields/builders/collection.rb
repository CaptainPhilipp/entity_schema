# frozen_string_literal: true

require_relative 'base'
require_relative 'object'
require_relative '../collection'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Collection < Builders::Object
        private

        def field_klass
          Fields::Collection
        end
      end
    end
  end
end
