# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Collection < Abstract
      # mapped tuple must be only in `objects` hash
      def base_set(attributes, objects, values)
        delete(attributes)
        write(objects, wrap(values))
      end

      # mapped tuple must be only in `objects` hash
      # prioritized operation - read once. in this case #delete will be called each time
      def base_get(attributes, objects)
        values = delete(attributes)
        values.nil? ? read(objects) : write(objects, wrap(values))
      end

      def serialize(output, objects)
        return unless exist?(objects)
        write(output, read(objects).map { |obj| obj.public_send(serialize_method) })
      end

      private

      def wrap(values)
        case values.first
        when map_to then values
        when Hash   then values.map { |value| map_to.public_send(map_method, value) }
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
