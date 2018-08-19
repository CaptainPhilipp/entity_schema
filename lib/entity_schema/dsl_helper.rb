# frozen_string_literal: true

module EntitySchema
  # TODO: remove this shit
  # TODO: doc
  module DslHelper
    def setup_field(field)
      remove_method(field.name)           if method_defined?(field.name)
      remove_method(field.predicate_name) if method_defined?(field.predicate_name)
      remove_method(field.setter_name)    if method_defined?(field.setter_name)

      schema.add_field field

      define_method(field.name) { field.get(self) }
      private(field.name) if field.private_getter?

      if field.predicate?
        define_method(field.predicate_name) { field.get(self) }
        private(field.predicate_name) if field.private_getter?
      end

      define_method(field.setter_name) { |value| field.set(self, value) }
      private(field.setter_name) if field.private_setter?
    end
  end
end
