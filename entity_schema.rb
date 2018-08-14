# frozen_string_literal: true

# main mixin for entity
module EntitySchema
  Undefined = Dry::Core::Constants::Undefined

  def self.extended(base)
    # TODO: юзать только один из extend миксинов
    base.extend  SchemaBuildingDsl # allow to define without `schema` block
    base.extend  SchemaDsl         # allow to define with `schema` block
    base.include InstanceMethods   # allow to use schema
  end
end
