# frozen_string_literal: true

module EntitySchema
  # aggregate of field resolvers
  class Schema
    attr_reader :owner, :object_fields

    def initialize(owner)
      @owner = owner
      @fields = {}
      @object_fields = {}
    end

    def extends(src)
      @fields = extract_schema(src).fields.merge(fields)
    end

    def add_field(name, field)
      fields[name] = field
    end

    def add_object_field(name, field)
      @object_fields[name] = field
      add_field(name, field)
    end

    def freeze
      fields.each do |name, field|
        name.freeze
        field.freeze
      end

      fields.freeze
      super
    end

    def get(attributes, objects, name)
      guard_unknown_field(name)

      fields[name].public_get(attributes, objects)
    end

    def set(attributes, objects, name, value)
      guard_unknown_field(name)

      fields[name].public_set(attributes, objects, value)
    end

    def serialize(attributes, objects)
      output = {}
      attributes.dup.tap do |output|
        objects.each_key do |key|
          self.class.schema.object_fields[key].serialize(output, objects)
        end
      end
      output
    end

    def fields_list
      fields.values
    end

    def field?(name)
      fields.key?(name)
    end

    def given?(attributes, objects, name)
      guard_unknown_field(name)
      fields[name].given?(attributes, objects)
    end

    def keys
      fields.values.map(&:src_key)
    end

    private

    attr_reader :fields

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
