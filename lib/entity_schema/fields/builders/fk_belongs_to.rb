# frozen_string_literal: true

require_relative 'abstract'
require_relative '../fk_belongs_to'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class FkBelongsTo < Abstract
        def create_field_params(o, name)
          super.merge!(predicate: false)
        end

        def field_klass
          Fields::FkBelongsTo
        end
      end
    end
  end
end
