# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # Fk
    class ObserverBelongsTo
      attr_reader :fk_resolver, :object_resolver, :pk

      def initialize(belongs_to, belongs_to_object, pk:)
        @fk_resolver     = belongs_to
        @object_resolver = belongs_to_object
        @pk              = pk
      end

      def fk_changed(new_fk, storage)
        object    = object_resolver.base_get(storage)
        object_pk = object&.public_send(pk)
        object_resolver.base_set(storage, nil, notify: false) if object_pk != new_fk
      end

      def object_changed(new_object, storage)
        fk_resolver.base_set(storage, new_object.public_send(pk), notify: false)
      end
    end
  end
end
