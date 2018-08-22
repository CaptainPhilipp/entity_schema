# frozen_string_literal: true

require_relative 'base'
require_relative '../object'

module EntitySchema
  module Fields
    module Specifications
      # TODO: doc
      class Object < Base
        private

        def transform_options(o)
          super.merge!(
            mapper:     find(callable(o[:mapper]),
                             owner_meth(o[:mapper]),
                             mapper(o[:map_to], o[:map_method]),
                             default_mapper),
            serializer: find(o[:serializer],
                             serializer(o))
          )
        end

        # helpers

        def mapper(map_to, map_method)
          return if map_to.nil?
          map_method ||= :new
          ->(hash) { map_to.public_send(map_method, hash) }
        end

        def default_mapper
          ->(hash) { hash }
        end

        def serializer(opts)
          map_method = opts[:serialize] || :to_h
          ->(object) { object.public_send(map_method) }
        end
      end
    end
  end
end
