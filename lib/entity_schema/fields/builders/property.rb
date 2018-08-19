# frozen_string_literal: true

require_relative 'abstract'
require_relative '../property'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class Property < Abstract
        private

        def extract_options(h)
          super.merge!(
            predicate: check!(:predicate, h, [true, false, nil])
          )
        end

        def create_field_params(o, name)
          super.merge!(
            predicate: to_bool(o[:predicate])
          )
        end

        def field_klass
          Fields::Property
        end
      end
    end
  end
end
