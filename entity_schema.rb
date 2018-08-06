# frozen_string_literal: true

module EntitySchema
  Undefined = Dry::Core::Constants::Undefined

  def self.extended(base)
    base.extend  SchemaBuildingDsl # allow to define without `schema` block
    base.extend  SchemaDsl         # allow to define with `schema` block
    base.include EntityMixin       # allow to use schema
  end
end
