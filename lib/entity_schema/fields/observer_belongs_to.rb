# frozen_string_literal: true

module EntitySchema
  module Fields
    # Doc
    class ObserverBelongsTo
      attr_reader :fk_field, :object_field, :object_pk_name

      def initialize(fk_belongs_to, object_belongs_to, object_pk_name:)
        @fk_field       = fk_belongs_to
        @object_field   = object_belongs_to
        @object_pk_name = object_pk_name
      end

      def fk_changed(new_fk, obj)
        object = object_field.get(obj)
        return if object.nil?
        old_fk = object.public_send(object_pk_name)
        object_field.set(obj, nil, notify_observer: false) if new_fk != old_fk
      end

      def object_changed(new_object, obj)
        new_pk =
          case new_object
          when Hash then new_object[object_pk_name]
          when nil  then nil
          else           new_object.public_send(object_pk_name)
          end
        fk_field.set(obj, new_pk, notify_observer: false)
      end
    end
  end
end
