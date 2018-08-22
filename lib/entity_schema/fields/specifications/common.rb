# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    module Specifications
      # TODO: doc
      # TODO: refactor overweight class
      # Builder is a Functional Object for creating Field using given options
      # In Abstract class defined interface and methods for processing any given options
      class Common < Abstract
        private

        def transform_options(input)
          super.merge!(
            name:           input[:name],
            owner_name:     input[:owner_name],
            src_key:        input[:key] || input[:name],
            public_getter: !eql(input, getter: :private, private: [:getter, true]),
            public_setter: !eql(input, setter: :private, private: [:setter, true])
          ) # .tap { |x| binding.pry if (input[:key] || input[:name]).nil? }
        end
      end
    end
  end
end
