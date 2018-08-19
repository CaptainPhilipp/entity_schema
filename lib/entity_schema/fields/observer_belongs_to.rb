# frozen_string_literal: true

module EntitySchema
  module Fields
    # Fk
    class ObserverBelongsTo
      attr_reader :fk_field, :object_field, :object_pk

      def initialize(fk_belongs_to, object_belongs_to, object_pk:)
        @fk_field     = fk_belongs_to
        @object_field = object_belongs_to
        @object_pk    = object_pk
      end

      def fk_changed(new_fk, obj)
        object = object_field.get(obj)
        return if object.nil?
        pk_value = object.public_send(object_pk)
        object_field.delete(obj) if pk_value != new_fk
      end

      def object_changed(new_object, obj)
        new_object_pk = new_object.is_a?(Hash) ? new_object[object_pk] : new_object.public_send(object_pk)
        fk_field.set(obj, new_object_pk, notify_observer: false)
      end
    end
  end
end
