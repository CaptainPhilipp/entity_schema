# frozen_string_literal: true

module EntitySchema
  module Resolvers
    # Fk
    class ObserverBelongsTo
      attr_reader :fk_resolver, :object_resolver, :pkey

      def initialize(belongs_to, belongs_to_object, pkey:)
        @fk_resolver     = belongs_to
        @object_resolver = belongs_to_object
        @pkey            = pkey
      end

      def fk_changed(new_fk, storage)
        return if object_resolver.base_get(storage)&.public_send(pkey) == new_fk
        object_resolver.base_set(storage, nil, notify: false)
      end

      def object_changed(new_object, storage)
        fk_resolver.base_set(storage, new_object.public_send(pkey), notify: false)
      end
    end
  end
end
