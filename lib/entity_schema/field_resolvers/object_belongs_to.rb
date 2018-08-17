# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
    # Withoutfk
    class ObjectBelongsTo < Object
      attr_accessor :observer_belongs_to

      def private_set(attributes, objects, value, notify: true)
        super(attributes, objects, value).tap do |new_object|
          observer_belongs_to.object_changed(new_object, objects) if notify
        end
      end
    end
  end
end
