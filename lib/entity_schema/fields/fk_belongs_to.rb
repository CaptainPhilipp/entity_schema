# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    # Fk
    class FkBelongsTo < Property
      attr_accessor :observer_belongs_to

      def initialize(options)
        @name    = options.delete(:fk)
        @src_key = @name
        options.delete(:src_key)
        super(options)
        guard_unknown_options!(options)
      end

      def set(obj, value, notify_observer: true)
        super(obj, value).tap do |fk|
          observer_belongs_to.fk_changed(fk, obj) if notify_observer
        end
      end
    end
  end
end
