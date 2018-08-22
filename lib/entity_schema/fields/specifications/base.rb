# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    module Specifications
      # TODO: doc
      # TODO: refactor overweight class
      # Builder is a Functional Object for creating Field using given options
      # In Abstract class defined interface and methods for processing any given options
      class Base < Abstract
        private

        def contract_options!(o)
          super.merge!(
            key:     contract!(:key,     o, [Symbol, nil]),
            getter:  contract!(:getter,  o, [:private, nil]),
            setter:  contract!(:setter,  o, [:private, nil]),
            private: contract!(:private, o, [true, false, :getter, :setter, nil])
          )
        end

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def transform_options(name, o)
          super.merge!(
            src_key:        find(o[:key], name),
            public_getter: !find(truth(o[:getter] == :private),
                                 truth(o[:private] == :getter),
                                 truth(o[:private]),
                                 false),
            public_setter: !find(truth(o[:setter] == :private),
                                 truth(o[:private] == :setter),
                                 truth(o[:private]),
                                 false)
          )
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
      end
    end
  end
end
