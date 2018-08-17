# frozen_string_literal: true

module EntitySchema
  module FieldResolvers
    # Fk
    class FkBelongsTo < Property
      attr_accessor :observer_belongs_to

      def private_set(attributes, objects, value, notify: true)
        super(attributes, objects, value).tap do |fk|
          observer_belongs_to.fk_changed(fk, attributes) if notify
        end
      end
    end
  end
end
