# frozen_string_literal: true

require_relative 'base'
require_relative '../fk_belongs_to'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class FkBelongsTo < Base
        def field_klass
          Fields::FkBelongsTo
        end
      end
    end
  end
end
