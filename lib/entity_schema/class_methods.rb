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
        if field.get_enabled?
          getter = field.name
          define_method(getter) { field.get(@attributes_, @objects_) }
          private(getter) if field.private_getter?
        end

        if field.set_enabled?
          setter = :"#{field.name}="
          define_method(setter) { |v| field.set(@attributes_, @objects_, v) }
          private(setter) if field.private_setter?
        end
      end
    end
  end
end
