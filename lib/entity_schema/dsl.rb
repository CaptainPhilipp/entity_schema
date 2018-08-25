# frozen_string_literal: true

require_relative 'transformers/property'
require_relative 'transformers/object'
require_relative 'transformers/collection'
require_relative 'transformers/belongs_to'

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
      options =   Transformers::Property.(name, to_s, nil, opts)
      setup_field Fields::Property.new(options)
    end

    def object(name, type = nil, **opts)
      Contracts::Object.(name, type, **opts)
      options =   Transformers::Object.(name, to_s, type, opts)
      setup_field Fields::Object.new(options)
    end

    alias has_one object

    def collection(name, type = nil, **opts)
      Contracts::Collection.(name, type, **opts)
      options =   Transformers::Collection.(name, to_s, type, opts)
      setup_field Fields::Collection.new(options)
    end

    alias has_many collection

    def belongs_to(name, type = nil, **opts)
      Contracts::BelongsTo.(name, type, **opts)
      options    = Transformers::BelongsTo.(name, to_s, type, opts)
      fk, object = Fields::Builders::BelongsTo.(options)
      setup_field(object)
      setup_field(fk)
    end

    private

    def __merge(opts, other)
      opts.merge(other) { |_, old, new| new.nil? ? old : new }
    end
  end
end
