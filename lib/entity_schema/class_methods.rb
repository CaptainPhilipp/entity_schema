# frozen_string_literal: true

require_relative 'schema'

module EntitySchema
  # TODO: doc
  module ClassMethods
    def schema
      @schema ||= Schema.new(self)
    end
  end
end
