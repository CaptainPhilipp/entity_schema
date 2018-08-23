# frozen_string_literal: true

require_relative 'base'
require_relative 'fk_belongs_to'
require_relative 'object_belongs_to'
require_relative '../observer_belongs_to'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class BelongsTo < Base
        def call(options)
          fk     = create_fk(options)
          object = create_object(options)
          create_observer(fk, object, options)
          [fk, object]
        end

        private

        def create_fk(opts)
          Fields::Builders::FkBelongsTo.(opts.slice(*fk_keys))
        end

        def create_object(opts)
          Fields::Builders::ObjectBelongsTo.(opts.slice(*object_keys))
        end

        def create_observer(fk, object, opts)
          observer = ObserverBelongsTo.new(fk, object, object_pk: opts[:pk] || :id)
          fk.observer_belongs_to     = observer
          object.observer_belongs_to = observer
        end

        def all_keys
          common_keys + only_object_keys + only_fk_keys
        end

        def object_keys
          common_keys + only_object_keys
        end

        def fk_keys
          common_keys + only_fk_keys
        end

        def only_object_keys
          %i[name mapper map_to map_method serialize_method serializer serialize]
        end

        def only_fk_keys
          %i[predicate fk fk_src_key]
        end

        def common_keys
          %i[owner_name src_key getter setter private public_setter public_getter]
        end

        def fk_name(fk_name, object_name)
          fk_name || :"#{object_name}_id"
        end

        def delete_keys(input_hash, keys)
          input_hash.slice(*keys).tap do
            keys.each { |k| input_hash.delete(k) }
          end
        end
      end
    end
  end
end
