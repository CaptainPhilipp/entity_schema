# frozen_string_literal: true

module EntitySchema
  # TODO: doc
  module SchemaBuildingDSL
    attr_writer :schema

    def schema
      @schema ||= Schema.new(self)
    end

    def property(name, key: name, hidden: false, setter: !hidden, getter: !hidden)
      schema.public_set name, Property.new(self, name, opts(key, setter, getter, hidden, mapper))
    end

    def property?(name, key: name, setter: true); end

    def object(name, **opts); end

    def belongs_to(obj_name, fk_name = nil, obj_pk_name = nil, **_opts)
      fk, pk = fk__pk(name, fk_name, obj_pk_name)

      belong_fk     = Resolvers::FkBelongsTo.new
      belong_object = Resolvers::ObjectBelongsTo.new

      observer = Resolvers::ObserverBelongsTo.new(belong_fk, belong_object, pkey: pk)

      belong_fk.belong_observer     = observer
      belong_object.belong_observer = observer

      schema.add_resolver(fk, belong_fk)
      schema.add_resolver(obj_name, belong_object)
    end

    # rubocop:disable Naming/PredicateName
    def has_one(name, **opts); end

    def has_many(name, **opts); end
    # rubocop:enable Naming/PredicateName

    def timestamps
      property :created_at, setter: false
      property :updated_at, setter: false
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    def fk__pk(name, fk, pk)
      if fk.nil? && pk.nil?
        [:"#{name}_id", :id]
      elsif fk && pk
        [fk, pk]
      elsif fk.is_a?(Hash) && fk.size == 1
        fk.to_a.first
      else
        raise ArgumentError, "Possible overloads: \n" \
              "belongs_to :foo, :foo_uid, :uid, ...\n" \
              "belongs_to :foo, { foo_uid: :uid }, ...\n" \
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

    def opts(key, setter, getter, hidden, mapper)
      { key: key, setter: setter, getter: getter, hidden: hidden, mapper: mapper }
    end
  end
end

# class Product
#   property  :id
#   property  :article
#   property  :enabled
#   property? :new,        key: :is_new
#   property? :sale,       key: :is_sale
#   property? :bestseller, key: :is_bestseller
#   timestamps

#   object :size, map_to: Size

#   belongs_to :color, { color_uid: :uid }, map_to: Color
#   has_many   :prices,                     map_to: Prices
#   has_many   :seasons,                    map_to: Season
#   has_many   :materials_products,         map_to: MaterialsProduct

#   def to_h
#     properties.unwrap_objects(:to_h, seasons: :serializable_hash).to_h
#   end
# end
