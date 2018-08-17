# frozen_string_literal: true

module EntitySchema
  # aggregate of field resolvers
  class Schema
    attr_reader :owner

    def initialize(owner)
      @owner = owner
      @all_fields = {}
      @object_fields = {}
    end

    def extends(src)
      @all_fields = extract_schema(src).fields.merge(fields)
      self
    end

    def add_field(name, field)
      all_fields[name] = field
    end

    def add_object_field(name, field)
      all_fields[name] = field
      object_fields[name] = field
    end

    def deep_freeze
      all_fields.each do |name, field|
        name.freeze
        field.freeze
      end.freeze
      freeze
    end

    def get(attributes, objects, name)
      guard_unknown_field(name)
      all_fields[name].public_get(attributes, objects)
    end

    def set(attributes, objects, name, value)
      guard_unknown_field(name)
      all_fields[name].public_set(attributes, objects, value)
    end

    def weak_set(attributes, objects, name, value)
      all_fields[name]&.weak_set(attributes, objects, value)
    end

    def serialize(attributes, objects)
      attributes.dup.tap do |output|
        objects.each_key do |key|
          object_fields[key]&.serialize(output, objects)
        end
      end
    end

    def fields_list
      all_fields.values
    end

    def field?(name)
      all_fields.key?(name)
    end

    def given?(attributes, objects, name)
      guard_unknown_field(name)
      all_fields[name].given?(attributes, objects)
    end

    def weak_given?(attributes, objects, name)
      all_fields[name]&.given?(attributes, objects)
    end

    def src_keys
      all_fields.values.map(&:src_key)
    end

    private

    attr_reader :all_fields, :object_fields

    def extract_schema(input)
      case input
      when self.class                 then input
      when input.respond_to?(:schema) then input.schema
      else raise ArgumentError
      end
    end

    def guard_unknown_field(name)
      return if field?(name)

      raise NameError, "Unknown field '#{name}' for `#{owner}`"
    end
  end
end
