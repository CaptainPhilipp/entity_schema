require 'entity_schema/version'

module EntitySchema
  # Your code goes here...
  def self.extended(base)
    base.extend ClassMethods
    base.extend Dsl
    base.extend InstanceMethods
  end
end
