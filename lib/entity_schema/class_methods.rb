# frozen_string_literal: true

module EntitySchema
  # TODO: doc
  module ClassMethods
    def schema
      @schema ||= Schema.new(self)
    end

    # TODO: maybe remove #finalize! and define methods in Dsl module
    # freeze schema and define readers and writers
    def finalize!
      return if @finalized_
      @finalized_ = true

      schema.deep_freeze
      schema.fields_list.each do |field|
        getter = field.name
        define_method(getter) { field.base_get(@attributes_, @objects_) }
        private(getter) if field.private_getter?

        if field.predicate?
          predicate = :"#{field.name}?"
          define_method(predicate) { field.base_get(@attributes_, @objects_) }
          private(predicate) if field.private_getter?
        end

        setter = :"#{field.name}="
        define_method(setter) { |input| field.base_set(@attributes_, @objects_, input) }
        private(setter) if field.private_setter?
      end
    end
  end
end
