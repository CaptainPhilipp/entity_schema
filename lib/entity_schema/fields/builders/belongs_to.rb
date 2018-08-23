# frozen_string_literal: true

require 'singleton'

require_relative '../fk_belongs_to'
require_relative '../object_belongs_to'
require_relative '../observer_belongs_to'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class BelongsTo
        include Singleton

        def call(options)
          fk     = create_fk(options)
          object = create_object(options)
          create_observer(fk, object, options)
          [fk, object]
        end

        def self.call(options)
          instance.call(options)
        end

        private

        def create_fk(opts)
          Fields::FkBelongsTo.new(opts)
        end

        def create_object(opts)
          Fields::ObjectBelongsTo.new(opts)
        end

        def create_observer(fk, object, opts)
          observer = ObserverBelongsTo.new(fk, object, object_pk: opts[:pk] || :id)
          fk.observer_belongs_to     = observer
          object.observer_belongs_to = observer
        end
      end
    end
  end
end
