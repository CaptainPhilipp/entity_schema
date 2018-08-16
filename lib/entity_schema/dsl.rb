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
      property(name, opts)
    end

    def object(_name, **_opts) end

    alias has_one object

    def belongs_to(_name, **_opts) end

    def collection(_name, **_opts) end

    alias has_many collection
  end
end
