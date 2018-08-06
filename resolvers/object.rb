# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # TODO: doc
    class Object < Base
      def base_set(storage, value)
        case value
        when map_to then write(storage, value)
        when Hash   then write(storage, map_to.public_send(map_method, value))
        when nil    then write(storage, nil_filler)
        else raise "Unexpected `#{name}` value type #{value.class}"
        end
      end

      def base_get(storage)
        value = read(storage)
        return value unless value.is_a?(Hash)
        write(storage, map_to.public_send(map_method, value))
      end
    end
  end
end
