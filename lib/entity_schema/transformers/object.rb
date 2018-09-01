# frozen_string_literal: true

require_relative 'common'

module EntitySchema
  module Transformers
    class Object < Common
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

      def mapper(map_to, map_method)
        return if map_to.nil?
        map_method ||= :new

        lambda do |hash|
          if map_to.is_a?(Class)
            map_to.public_send(map_method, hash)
          else
            Object.const_get(map_to).public_send(map_method, hash)
          end
        end
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
