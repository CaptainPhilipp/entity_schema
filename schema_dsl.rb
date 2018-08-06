# frozen_string_literal: true

require 'dry/core/class_builder'

module EntitySchema
  # TODO: doc
  module SchemaDSL
    def schema(_opts = {})
      return @schema unless block_given?

      @schema        ||= Schema.new(self)
      @schema_klass_ ||= Class.new.tap do |klass|
        klass.extend SchemaBuildingDSL
        klass.schema = @schema
      end

      @schema_klass_.class_eval { yield }
      @schema
    end

    def finalize!
      return if @finalized_
      @finalized_ = true

      schema.freeze
      schema.resolvers_list.each do |resolver|
        name = resolver.name
        define_method(name) { resolver.public_get(attributes) } if resolver.public_get?
        define_method(:"#{name}=") { |v| resolver.public_set(attributes, v) } if resolver.public_set?
      end
    end
  end
end
