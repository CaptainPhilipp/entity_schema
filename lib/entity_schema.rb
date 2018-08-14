# frozen_string_literal: true

require 'entity_schema/version'

module EntitySchema
  def self.extended(base)
    base.extend ClassMethods
    base.extend Dsl
    base.extend InstanceMethods
  end
end
