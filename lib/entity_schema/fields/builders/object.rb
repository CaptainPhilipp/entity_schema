# frozen_string_literal: true

require_relative 'base'
require_relative '../object'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Object < Base
        private

        def extract_options(o)
          super.merge!(
            mapper:     check!(:mapper,     o, [Symbol, nil], [:call]),
            map_to:     check!(:map_to,     o, [Class, nil]),
            map_method: check!(:map_method, o, [Symbol, nil]),
            serializer: check!(:serializer, o, [Symbol, nil], [:call]),
            serialize:  check!(:serialize,  o, [Symbol, nil])
          )
        end

        # TODO: test default_mapper, :mapper, :serializer
        def create_field_params(name, owner, o)
          super.merge!(
            mapper: find(callable(o[:mapper]),
                         owner_meth(o[:mapper], owner),
                         mapper(o[:map_to], o[:map_method]),
                         default_mapper),
            serializer: find(o[:serializer],
                             build_serializer(o))
          )
        end

        def mapper(map_to, map_method)
          return if map_to.nil?
          map_method ||= :new
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
