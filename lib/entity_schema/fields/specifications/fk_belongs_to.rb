# frozen_string_literal: true

require_relative 'common'

module EntitySchema
  module Fields
    module Specifications
      # TODO: doc
      class FkBelongsTo < Common
        def transform_options(_name, _owner, _options)
          super.merge!(predicate: false)
        end
      end
    end
  end
end
