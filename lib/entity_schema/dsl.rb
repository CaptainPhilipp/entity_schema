# frozen_string_literal: true

require_relative 'fields/builders/property'
require_relative 'fields/builders/object'
require_relative 'dsl_helper'


module EntitySchema
  # class-level methods for define schema
  module Dsl
    include DslHelper

    def property(name, **opts)
      setup_field Fields::Builders::Property.(name, schema, opts)
    end

    def property?(name, **opts)
      opts.merge! predicate: true
      property(name, opts)
    end

    def object(name, **opts)
      setup_field Fields::Builders::Object.(name, schema, opts)
    end

    alias has_one object

    def belongs_to(_name, **_opts) end

    def collection(_name, **_opts) end

    alias has_many collection
  end
end
