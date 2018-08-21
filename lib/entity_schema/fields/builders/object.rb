# frozen_string_literal: true

require_relative 'abstract'
require_relative '../object'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Object < Abstract
        private

        # rubocop:disable Naming/UncommunicativeMethodParamName
        def extract_options(h)
          super.merge!(
            mapper:     check_ducktype!(:mapper, h, [:call]),
            map_to:     check!(:map_to, h, [Class, nil]),
            map_method: check!(:map_method, h, [Symbol, nil]),
            serializer: check_ducktype!(:serializer, h, [:call]),
            serialize:  check!(:serialize, h, [Symbol, nil])
          )
        end
        # rubocop:enable Naming/UncommunicativeMethodParamName

        # TODO: test default_mapper, :mapper, :serializer
        def create_field_params(opts, name)
          super.merge!(
            mapper:     first_of(opts[:mapper],     build_mapper(opts), default_mapper),
            serializer: first_of(opts[:serializer], build_serializer(opts))
          )
        end

        def build_mapper(opts)
          return if opts[:map_to].nil?

          map_to     = opts[:map_to]
          map_method = opts[:map_method] || :new
          ->(hash) { map_to.public_send(map_method, hash) }
        end

        def default_mapper
          ->(hash) { hash }
        end

        def build_serializer(opts)
          map_method = opts[:serialize] || :to_h
          ->(object) { object.public_send(map_method) }
        end

        def field_klass
          Fields::Object
        end
      end
    end
  end
end
