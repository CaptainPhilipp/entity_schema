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
        name = field.name
        define_method(name) { field.public_get(@attributes_, @objects_) } if field.get_enabled?
        define_method(:"#{name}=") { |v| field.public_set(@attributes_, @objects_, v) } if field.set_enabled?
      end
    end
  end
end
