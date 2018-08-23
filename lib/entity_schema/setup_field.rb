# frozen_string_literal: true

module EntitySchema
  # Define or redefine methods for work with Entity fields
  module SetupField
    def setup_field(field, spec)
      entity_schema.add_field(field)

      setup_getter(field)
      setup_setter(field)
      setup_predicate(field) if spec.predicate?
    end

    def setup_getter(field)
      m = field.name
      define_method(m) { field.get(self) }
      public(m)  if     field.public_getter?
      private(m) unless field.public_getter?
    end

    def setup_setter(field)
      m = :"#{field.name}="
      define_method(m) { |value| field.set(self, value) }
      public(m)  if     field.public_setter?
      private(m) unless field.public_setter?
    end

    def setup_predicate(field)
      m = :"#{field.name}?"
      remove_method(m) if method_defined?(m)
      define_method(m) { field.get(self) }
      public(m)  if     field.public_getter?
      private(m) unless field.public_getter?
    end
  end
end
