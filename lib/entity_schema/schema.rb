# frozen_string_literal: true

module EntitySchema
  # aggregate of field resolvers
  class Schema
    attr_reader :owner_name

    def initialize(owner_name:, extends: nil)
      @owner_name = owner_name

      if extends
        @fields        = extends.fields
        @fields_by_key = extends.fields_by_key
      else
        @fields        = {}
        @fields_by_key = {}
      end
    end

    def add_field(field)
      fields[field.name]           = field
      fields_by_key[field.src_key] = field
    end

    def set_from_params(obj, params)
      params.each { |key, value| fields_by_key[key]&.set(obj, value) }
    end

    def public_set(obj, name, value)
      guard_unknown_field!(name)
      fields[name].public_set(obj, value)
    end

    def public_get(obj, name)
      guard_unknown_field!(name)
      fields[name].public_get(obj)
    end

    def serialize(obj)
      fields.values.each_with_object({}) { |field, output| field.serialize(obj, output) }
    end

    def field?(name)
      fields.key?(name)
    end

    def given?(obj, name)
      guard_unknown_field!(name)
      fields[name].given?(obj)
    end

    def weak_given?(obj, name)
      fields[name]&.given?(obj)
    end

    # TODO: use it
    def deep_freeze
      fields.each do |name, field|
        name.freeze
        field.freeze
      end.freeze
      freeze
    end

    protected

    attr_reader :fields, :fields_by_key

    private

    def guard_unknown_field!(name)
      return if field?(name)
      raise NameError, "Unknown field '#{name}' for `#{owner_name}`"
    end
  end
end
