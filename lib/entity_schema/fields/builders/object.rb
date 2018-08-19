# frozen_string_literal: true

require_relative 'abstract'
require_relative '../object'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class Object < Abstract
        private

        def extract_options(h)
          super.merge!(
            mapper:           check_ducktype!(:mapper, h, [:call]),
            map_to:           check!(:map_to, h, [Class]),
            map_method:       check!(:map_method, h, [Symbol, nil]),
            serialize_method: check!(:serialize, h, [Symbol, nil]),
            serializer:       check_ducktype!(:serializer, h, [:call])
          )
        end

        def create_field_params(o, name)
          super.merge!(
            map_to:           o[:map_to],
            map_method:       o[:map_method] || :new,
            serialize_method: o[:serialize_method] || :to_h
          )
        end

        def field_klass
          Fields::Object
        end
      end
    end
  end
end
