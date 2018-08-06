# frozen_string_literal: true

module EntitySchema
  # Interface for build and usage schema
  class Schema
    attr_reader :owner

    def initialize(owner)
      @owner     = owner
      @resolvers = {}
    end

    def add_resolver(name, resolver)
      resolvers[name] = resolver
    end

    def freeze
      resolvers.each do |name, resolver|
        name.freeze
        resolver.freeze
      end

      resolvers.freeze
      super
    end

    def get(attributes, name, default: Undefined)
      raise_unknown_resolver(name) unless resolver?(name)

      resolvers[name].public_get(attributes, default: default)
    end

    def set(attributes, name, value)
      raise_unknown_resolver(name) unless resolver?(name)

      resolvers[name].public_set(attributes, value)
    end

    def resolvers_list
      resolvers.values
    end

    def resolver?(name)
      resolvers.key?(name)
    end

    def names
      resolvers.keys
    end

    private

    attr_reader :resolvers

    def raise_unknown_resolver(name)
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

  def to_h
    unwrap_objects(:to_h, seasons: :serializable_hash).to_h
  end
end
