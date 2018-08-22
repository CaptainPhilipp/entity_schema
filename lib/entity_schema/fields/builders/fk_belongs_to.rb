# frozen_string_literal: true

require_relative 'base'
require_relative '../fk_belongs_to'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class FkBelongsTo < Common
        def create_field_params(_name, _owner, _options)
          super.merge!(predicate: false)
        end

        def field_klass
          Fields::FkBelongsTo
        end
      end
    end
  end
end
