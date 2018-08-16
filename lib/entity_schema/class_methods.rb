# frozen_string_literal: true

module EntitySchema
  # TODO: дистилировать ответственность сущности и переименовать
  # allow to define schema in `schema do` block
  module ClassMethods
    # @example
    #   schema do
    #     property :foo
    #     property :bar
    #   end
    def schema(_opts = {})
      @schema ||= Schema.new(self)
    end

    # freeze schema and define readers and writers
    def finalize!
      return if @finalized_
      @finalized_ = true

      schema.freeze
      # TODO: define predicates
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
