# frozen_string_literal: true

require_relative 'base'
require_relative '../property'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Property < Base
        private

        # rubocop:disable Naming/UncommunicativeMethodParamName
        def extract_options(h)
          super.merge!(
            predicate: check!(:predicate, h, [true, false, nil])
          )
        end

        def create_field_params(name, _owner, o)
          super.merge!(
            predicate: to_bool(o[:predicate])
          )
        end
        # rubocop:enable Naming/UncommunicativeMethodParamName

        def field_klass
          Fields::Property
        end
      end
    end
  end
end
