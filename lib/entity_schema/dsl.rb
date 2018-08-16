# frozen_string_literal: true

require_relative 'field_resolvers/builders/property'


module EntitySchema
  # class-level methods for define schema
  module Dsl
    def property(name, **opts)
      schema.add_field name, FieldResolvers::Builders::Property.(name, schema, opts)
    end

    def property?(name, **opts)
      opts.merge! predicate: true
      schema.add_field name, FieldResolvers::Builders::Property.(name, schema, opts)
    end

    # def object(name, **opts); end

    # def belongs_to(obj_name, fk_name = nil, obj_pk_name = nil, **_opts)
    #   fk, pk = fk__pk(name, fk_name, obj_pk_name)

    #   fk_belongs_to     = FieldResolvers::FkBelongsTo.new
    #   object_belongs_to = FieldResolvers::ObjectBelongsTo.new

    #   observer = FieldResolvers::ObserverBelongsTo.new(fk_belongs_to, object_belongs_to, object_pk: pk)

    #   fk_belongs_to.observer_belongs_to     = observer
    #   object_belongs_to.observer_belongs_to = observer

    #   schema.add_field(fk, fk_belongs_to)
    #   schema.add_field(obj_name, object_belongs_to)
    # end

    # # rubocop:disable Naming/PredicateName
    # def has_one(name, **opts); end

    # def has_many(name, **opts); end
    # # rubocop:enable Naming/PredicateName

    # def timestamps(setter: false)
    #   property :created_at, setter: setter
    #   property :updated_at, setter: setter
    # end

    private
    def fk__pk(name, fk, pk)
      if fk.nil? && pk.nil?
        [:"#{name}_id", :id]
      elsif fk.is_a?(Hash) && fk.size == 1
        fk.to_a.first
      else
        raise ArgumentError, "Possible overloads: \n" \
                             "belongs_to :foo, { foo_uid: :uid }, ...\n" \
                             "belongs_to :foo, ...\n" \
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  end
end
