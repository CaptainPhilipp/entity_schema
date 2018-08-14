# frozen_string_literal: true

require 'dry/core/class_builder'

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
        define_method(name) { field.public_get(@attributes, @objects) } if field.public_get?
        define_method(:"#{name}=") { |v| field.public_set(@attributes, @objects, v) } if field.public_set?
      end
    end
  end
end
