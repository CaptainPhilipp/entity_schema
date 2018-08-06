# frozen_string_literal: true

module EntitySchema
  module Fields
    # TODO: doc
    class Property < Abstract
      def base_set(attributes, _objects, value)
        write(attributes, value)
      end

      def base_get(attributes, _objects)
        read(attributes)
      end
    end
  end
end
