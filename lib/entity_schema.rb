# frozen_string_literal: true

require 'entity_schema/version'

require 'entity_schema/class_methods'
require 'entity_schema/dsl'
require 'entity_schema/instance_methods'

module EntitySchema
  Undefined = :undefined
  EMPTY_HASH = {}.freeze # TODO: EMPTY_HASH from Dry Core

  def self.extended(base)
    base.extend ClassMethods
    base.extend Dsl
    base.include InstanceMethods
  end
end
