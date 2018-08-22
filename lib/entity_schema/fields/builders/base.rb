# frozen_string_literal: true

require 'singleton'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      # TODO: refactor overweight class
      # Builder is a Functional Object for creating Field using given options
      # In Abstract class defined interface and methods for processing any given options
      # ? may be extract options processing to another class
      class Base
        include Singleton

        def self.call(*args)
          instance.call(*args)
        end

        def call(options)
          field_klass.new(**options)
        end

        private

        # :nocov:
        def field_klass
          raise NotImplementedError
        end
        # :nocov:
      end
    end
  end
end
