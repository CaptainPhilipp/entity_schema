# frozen_string_literal: true

require_relative 'specifications/property'
require_relative 'specifications/object'
require_relative 'specifications/collection'
require_relative 'specifications/belongs_to'

require_relative 'contracts/property'
require_relative 'contracts/object'
require_relative 'contracts/collection'
require_relative 'contracts/belongs_to'

require_relative 'fields/property'
require_relative 'fields/object'
require_relative 'fields/collection'
require_relative 'builders/belongs_to'

require_relative 'setup_field'

module EntitySchema
  # class-level methods for define entity_schema
  module Dsl
    include SetupField

    def property?(name, **opts)
      property(name, opts.merge!(predicate: true))
    end

    def property(name, **opts)
      Contracts::Property.(name, **opts)
      specicifation = Specifications::Property.new(name, to_s, opts)
      field         = Fields::Property.new(specicifation)
      setup_field(field, specicifation)
    end

    def object(name, map_to = nil, **opts)
      Contracts::Object.(name, map_to, **opts)
      specicifation = Specifications::Object.new(name, to_s, __merge(opts, map_to: map_to))
      field         = Fields::Object.new(specicifation)
      setup_field(field, specicifation)
    end

    alias has_one object

    def collection(name, map_to = nil, **opts)
      Contracts::Collection.(name, map_to, **opts)
      specicifation = Specifications::Collection.new(name, to_s, __merge(opts, map_to: map_to))
      field         = Fields::Collection.new(specicifation)
      setup_field(field, specicifation)
    end

    alias has_many collection

    def belongs_to(name, map_to = nil, **opts)
      Contracts::BelongsTo.(name, map_to, **opts)
      specicifation = Specifications::BelongsTo.new(name, to_s, __merge(opts, map_to: map_to))
      fk, object    = Fields::Builders::BelongsTo.(specicifation)
      setup_field(object, specicifation)
      setup_field(fk, specicifation)
    end

    private

    def __merge(opts, other)
      opts.merge(other) { |_, old, new| new.nil? ? old : new }
    end
  end
end
