# frozen_string_literal: true

module EntitySchema
  # class-level methods for define schema
  module SchemaBuildingDsl
    def schema
      @schema ||= Schema.new(self)
    end

    # TODO: specification вместо просто хеша параметров
    # TODO: билдер вместо простого создания инлайн
    def property(name, key: name, hidden: false, setter: !hidden, getter: !hidden)
      schema.add_field name, Property.new(self, name, opts(key, setter, getter, hidden, mapper))
    end

    # TODO: method_name
    def property?(name, key: name, setter: true); end

    def object(name, **opts); end

    def belongs_to(obj_name, fk_name = nil, obj_pk_name = nil, **_opts)
      fk, pk = fk__pk(name, fk_name, obj_pk_name)

      fk_belongs_to     = FieldResolvers::FkBelongsTo.new
      object_belongs_to = FieldResolvers::ObjectBelongsTo.new

      observer = FieldResolvers::ObserverBelongsTo.new(fk_belongs_to, object_belongs_to, object_pk: pk)

      fk_belongs_to.observer_belongs_to     = observer
      object_belongs_to.observer_belongs_to = observer

      schema.add_field(fk, fk_belongs_to)
      schema.add_field(obj_name, object_belongs_to)
    end

    # rubocop:disable Naming/PredicateName
    def has_one(name, **opts); end

    def has_many(name, **opts); end
    # rubocop:enable Naming/PredicateName

    def timestamps(setter: false)
      property :created_at, setter: setter
      property :updated_at, setter: setter
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    def fk__pk(name, fk, pk)
      if fk.nil? && pk.nil?
        [:"#{name}_id", :id]
      elsif fk.is_a?(Hash) && fk.size == 1
        fk.to_a.first
      else
        raise ArgumentError, "Possible overloads: \n" \
                             "belongs_to :foo, { foo_uid: :uid }, ...\n" \
                             "belongs_to :foo, ...\n" \
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

    def opts(key, setter, getter, hidden, mapper)
      { key: key, setter: setter, getter: getter, hidden: hidden, mapper: mapper }
    end
  end
end

class Product
  property  :id
  property  :article
  property  :enabled
  property  :new?,        key: :is_new
  property  :sale?,       key: :is_sale
  property  :bestseller?, key: :is_bestseller
  timestamps

  object :size, map_to: Size

  belongs_to :color, { color_uid: :uid }, map_to: Color
  has_many   :prices,                     map_to: Prices
  has_many   :seasons,                    map_to: Season
  has_many   :materials_products,         map_to: MaterialsProduct

  def to_h
    properties.unwrap_objects(:to_h, seasons: :serializable_hash).to_h
  end
end
