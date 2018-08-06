# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # Fk
    class FkBelongsTo < Base
      attr_accessor :belong_observer

      def base_set(storage, value, notify: true)
        write(storage, value).tap do |fk|
          belong_observer.fk_changed(fk, storage) if notify
        end
      end
    end
  end
end
