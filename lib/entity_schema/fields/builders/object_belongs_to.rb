# frozen_string_literal: true

require_relative 'object'
require_relative '../object_belongs_to'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class ObjectBelongsTo < Builders::Object
        def field_klass
          Fields::ObjectBelongsTo
        end
      end
    end
  end
end
