# frozen_string_literal: true

require 'singleton'
require_relative 'options_processing_mixin'

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
        include OptionsProcessingMixin

        def self.call(*args)
          instance.call(*args)
        end

        def call(name, owner, options)
          opts = extract_options(options)
          guard_unknown_options!(options, name)

          params = create_field_params(name, owner, opts)
          create_field(name, owner, params)
        end

        private

        def extract_options(o)
          {
            key:     check!(:key,     o, [Symbol, nil]),
            getter:  check!(:getter,  o, [:private, nil]),
            setter:  check!(:setter,  o, [:private, nil]),
            private: check!(:private, o, [true, false, :getter, :setter, nil])
          }
        end

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def create_field_params(name, _owner, o)
          {
            src_key:        find(o[:key], name),
            public_getter: !find(truth(o[:getter] == :private),
                                 truth(o[:private] == :getter),
                                 truth(o[:private]),
                                 false),
            public_setter: !find(truth(o[:setter] == :private),
                                 truth(o[:private] == :setter),
                                 truth(o[:private]),
                                 false)
          }
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

        def create_field(name, owner, params)
          field_klass.new(name, owner.to_s, **params)
        end

        # :nocov:
        def field_klass
          raise NotImplementedError
        end
        # :nocov:
      end
    end
  end
end
