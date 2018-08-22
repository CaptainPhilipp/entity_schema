# frozen_string_literal: true

require_relative 'common'
require_relative 'fk_belongs_to'
require_relative 'object_belongs_to'

module EntitySchema
  module Fields
    module Specifications
      # TODO: doc
      class BelongsTo < Object
        private

        def transform_options(opts)
          super.merge!(
            fk_name:    opts[:fk] || :"#{opts[:name]}_id",
            fk_src_key: opts[:fk] || :"#{opts[:src_key]}_id"
          )
        end
      end
    end
  end
end
