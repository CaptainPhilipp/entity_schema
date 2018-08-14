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
      raise_unknown_field(name) unless field?(name)

      fields[name].public_get(attributes, objects)
    end

    def set(attributes, objects, name, value)
      raise_unknown_field(name) unless field?(name)

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
      raise "Unknown field '#{name}'" unless field?(name)
      fields[name].given?(attributes, objects)
    end

    def names
      fields.keys
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

    def raise_unknown_field(name)
      raise "Unknown attribute `#{name}`"
    end
  end
end

class Product
  property  :id, key: :uid
  property  :article
  property  :enabled
  property? :new,        key: :is_new
  property? :sale,       key: :is_sale
  property? :bestseller, key: :is_bestseller
  timestamps

  object :size, map_to: Size

  belongs_to :color, { color_uid: :uid }, map_to: Color
  has_many   :prices,                     map_to: Prices
  has_many   :seasons,                    map_to: Season
  has_many   :materials_products,         map_to: MaterialsProduct
end
