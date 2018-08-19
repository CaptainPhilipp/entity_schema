# frozen_string_literal: true

require_relative 'abstract'
require_relative 'fk_belongs_to'
require_relative 'object_belongs_to'
require_relative '../observer_belongs_to'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class BelongsTo < Abstract
        def call(name, schema, options)
          options = options.dup
          opts = extract_options(options)
          guard_unknown_options!(options, name)

          fk     = create_fk(name, schema, opts)
          object = create_object(name, schema, opts)

          create_observer(fk, object, opts)
          [fk, object]
        end

        private

        def extract_options(h)
          delete_keys(h, all_keys).merge!(
            pk: check!(:pk, h, [Symbol, nil]),
            fk: check!(:fk, h, [Symbol, nil])
          )
        end

        def create_fk(object_name, schema, opts)
          name = fk_name(opts[:fk], object_name)
          Fields::Builders::FkBelongsTo.(name, schema, create_fk_params(opts, name))
        end

        def create_fk_params(opts, name)
          opts.slice(*fk_keys).merge!(key: name)
        end

        def create_object(name, schema, opts)
          Fields::Builders::ObjectBelongsTo.(name, schema, opts.slice(*object_keys))
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
          %i[mapper map_to map_method serialize_method serializer serialize]
        end

        def only_fk_keys
          [:predicate]
        end

        def common_keys
          %i[key getter setter private]
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
