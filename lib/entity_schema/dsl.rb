# frozen_string_literal: true

require_relative 'fields/specifications/property'
require_relative 'fields/specifications/object'
require_relative 'fields/specifications/collection'
require_relative 'fields/specifications/belongs_to'

require_relative 'fields/contracts/property'
require_relative 'fields/contracts/object'
require_relative 'fields/contracts/collection'
require_relative 'fields/contracts/belongs_to'

require_relative 'fields/builders/property'
require_relative 'fields/builders/object'
require_relative 'fields/builders/collection'
require_relative 'fields/builders/belongs_to'

require_relative 'setup_field'

module EntitySchema
  # class-level methods for define entity_schema
  module Dsl
    include SetupField

    def property?(name, **opts)
      property(name, opts.merge!(predicate: true))
    end

    def property(name, **opts)
      Fields::Contracts::Property.(name, to_s, opts)
      specicifation = Fields::Specifications::Property.new(name, to_s, opts)
      field         = Fields::Builders::Property.(specicifation.to_h)
      setup_field(field, specicifation)
    end

    def object(name, **opts)
      Fields::Contracts::Object.(name, to_s, opts)
      specicifation = Fields::Specifications::Object.new(name, to_s, opts)
      field         = Fields::Builders::Object.(specicifation.to_h)
      setup_field(field, specicifation)
    end

    alias has_one object

    def collection(name, **opts)
      Fields::Contracts::Collection.(name, to_s, opts)
      specicifation = Fields::Specifications::Collection.new(name, to_s, opts)
      field         = Fields::Builders::Collection.(specicifation.to_h)
      setup_field(field, specicifation)
    end

    alias has_many collection

    def belongs_to(name, **opts)
      Fields::Contracts::BelongsTo.(name, to_s, opts)
      specicifation = Fields::Specifications::BelongsTo.new(name, to_s, opts)
      fk, object = Fields::Builders::BelongsTo.(specicifation.to_h)
      setup_field(object, specicifation)
      setup_field(fk, specicifation)
    end
  end
end
