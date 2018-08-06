# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # Fk
    class FkBelongsTo < Property
      attr_accessor :belong_observer

      def base_set(storage, value, notify: true)
        super.tap do |fk|
          belong_observer.fk_changed(fk, storage) if notify
        end
      end
    end
  end
end
