# frozen_string_literal: true

require_relative 'abstract'
require_relative 'object'
require_relative '../collection'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class Collection < Builders::Object
        private

        def field_klass
          Fields::Collection
        end
      end
    end
  end
end
