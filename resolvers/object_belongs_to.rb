# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # Withoutfk
    class ObjectBelongsTo < Base
      attr_accessor :belong_observer

      def base_set(storage, _value, notify: true)
        super.tap do |object|
          belong_observer.object_changed(object, storage) if notify
        end
      end
    end
  end
end
