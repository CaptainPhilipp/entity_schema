# frozen_string_literal: true

require_relative 'fields/specifications/property'
require_relative 'fields/specifications/object'
require_relative 'fields/specifications/collection'
require_relative 'fields/specifications/belongs_to'

require_relative 'fields/builders/property'
require_relative 'fields/builders/object'
require_relative 'fields/builders/collection'
require_relative 'fields/builders/belongs_to'

require_relative 'dsl_helper'

module EntitySchema
  # class-level methods for define entity_schema
  module Dsl
    include DslHelper

    def property?(name, **opts)
      property(name, opts.merge!(predicate: true))
    end

    def property(name, **opts)
      specicifation = Fields::Specifications::Property.new(name, to_s, opts)
      field = Fields::Builders::Property.(name, self, specicifation.to_h)
      setup_field(field, specicifation)
    end

    def object(name, **opts)
      setup_field Fields::Builders::Object.(name, self, opts)
    end

    alias has_one object

    def collection(name, **opts)
      setup_field Fields::Builders::Collection.(name, self, opts)
    end

    alias has_many collection

    def belongs_to(name, **opts)
      fk, object = Fields::Builders::BelongsTo.(name, self, opts)
      setup_field object
      setup_field fk
    end
  end
end
