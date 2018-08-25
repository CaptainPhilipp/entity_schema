# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Transformers
    class Common < Abstract
      private

      def transform_options(input)
        super.merge!(
          name:           input[:name],
          src_key:        input[:key] || input[:name],
          owner_name:     input[:owner_name],
          public_getter: !eql(input, getter: :private, private: [:getter, true]),
          public_setter: !eql(input, setter: :private, private: [:setter, true]),
          predicate:      false
        )
      end
    end
  end
end
