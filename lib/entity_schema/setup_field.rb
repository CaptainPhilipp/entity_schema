# frozen_string_literal: true

module EntitySchema
  # TODO: doc
  module SetupField
    def setup_field(field, spec)
      remove_method(name)           if method_defined?(name)
      remove_method(predicate_name) if method_defined?(predicate_name)
      remove_method(setter_name)    if method_defined?(setter_name)

      entity_schema.add_field(field)

      setup_getter(field, spec)
      setup_setter(field, spec)
      setup_predicate(field, spec) if spec.predicate?
    end

    def setup_getter(field, spec)
      define_method(field.name) { field.get(self) }
      private(field.name) unless spec.public_getter?
    end

    def setup_setter(field, spec)
      define_method(:"#{field.name}=") { |value| field.set(self, value) }
      private(:"#{field.name}=") unless spec.public_setter?
    end

    def setup_predicate(field, spec)
      define_method(:"#{field.name}?") { field.get(self) }
      private(:"#{field.name}?") unless spec.public_getter?
    end
  end
end
