# frozen_string_literal: true

require_relative 'common'
require_relative 'fk_belongs_to'
require_relative 'object_belongs_to'

module EntitySchema
  module Specifications
    class BelongsTo < Object
      private

      def transform_options(opts)
        super.merge!(
          fk:         opts[:fk] || :"#{opts[:name]}_id",
          pk:         opts[:pk] || :id
        )
      end
    end
  end
end
