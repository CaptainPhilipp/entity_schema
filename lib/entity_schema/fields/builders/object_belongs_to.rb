# frozen_string_literal: true

require_relative 'base'
require_relative '../object_belongs_to'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class ObjectBelongsTo < Builders::Object
        def field_klass
          Fields::ObjectBelongsTo
        end
      end
    end
  end
end
