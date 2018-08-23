# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    # Withoutfk
    class ObjectBelongsTo < Object
      attr_accessor :observer_belongs_to

      def set(obj, value, notify_observer: true)
        super(obj, value).tap do |new_object|
          observer_belongs_to.object_changed(new_object, obj) if notify_observer
        end
      end
    end
  end
end
