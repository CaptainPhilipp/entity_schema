# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Object < Abstract
      # mapped tuple must be only in `objects` hash
      def base_set(attributes, objects, value)
        delete(attributes)
        write(objects, wrap(value))
      end

      # mapped tuple must be only in `objects` hash
      # prioritized operation - read once. in this case #delete will be called each time
      def base_get(attributes, objects)
        tuple = delete(attributes)
        tuple.nil? ? read(objects) : write(objects, wrap(tuple))
      end

      def serialize(output, objects)
        return unless exist?(objects)
        write(output, read(objects).public_send(serialize_method))
      end

      private

      attr_reader :serialize_method

      def configure(opts)
        @serialize_method = opts.delete(:serialize) || :to_h
        super
      end

      def wrap(value)
        case value
        when map_to then value
        when Hash   then map_to.public_send(map_method, value)
        when nil    then nil_filler
        else raise "Unexpected `#{name}` value type #{value.class}"
        end
      end

      def delete(attributes)
        attributes.delete(src_key)
      end
    end
  end
end
