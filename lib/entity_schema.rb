# frozen_string_literal: true

require 'singleton'

require 'entity_schema/version'
require 'entity_schema/class_methods'
require 'entity_schema/dsl'
require 'entity_schema/instance_methods'
require 'entity_schema/schema'

module EntitySchema
  Undefined = :undefined

  def self.extended(base)
    base.extend ClassMethods
    base.extend Dsl
    base.include InstanceMethods
  end
end
