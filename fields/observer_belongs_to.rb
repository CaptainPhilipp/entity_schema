# frozen_string_literal: true

module EntitySchema
  module Fields
    # Fk
    class ObserverBelongsTo
      attr_reader :fk_field, :object_field, :pk

      def initialize(fk_belongs_to, object_belongs_to, object_pk:)
        @fk_field     = fk_belongs_to
        @object_field = object_belongs_to
        @object_pk    = object_pk
      end

      def fk_changed(new_fk, objects)
        object    = object_field.base_get(objects)
        object_pk = object&.public_send(object_pk)
        object_field.base_set(objects, nil, notify: false) if object_pk != new_fk
      end

      def object_changed(new_object, objects)
        fk_field.base_set(objects, new_object.public_send(object_pk), notify: false)
      end
    end
  end
end
