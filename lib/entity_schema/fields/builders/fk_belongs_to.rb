# frozen_string_literal: true

require_relative 'abstract'
require_relative '../fk_belongs_to'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class FkBelongsTo < Abstract
        def create_field_params(name, _owner, o)
          super.merge!(predicate: false)
        end

        def field_klass
          Fields::FkBelongsTo
        end
      end
    end
  end
end
