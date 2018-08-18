# frozen_string_literal: true

require_relative 'field_resolvers/builders/property'
require_relative 'field_resolvers/builders/object'

module EntitySchema
  # class-level methods for define schema
  module Dsl
    def property(name, **opts)
      setup_field FieldResolvers::Builders::Property.(name, schema, opts)
    end

    def property?(name, **opts)
      opts.merge! predicate: true
      property(name, opts)
    end

    def object(name, **opts)
      setup_field FieldResolvers::Builders::Object.(name, schema, opts)
    end

    alias has_one object

    def belongs_to(_name, **_opts) end

    def collection(_name, **_opts) end

    alias has_many collection

    private

    def setup_field(field)
      field.setup_field(self)
      schema.add_field field
    end
  end
end
