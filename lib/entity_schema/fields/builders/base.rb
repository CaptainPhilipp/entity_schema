# frozen_string_literal: true

require_relative 'abstract'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Base < Abstract
        private

        def extract_options(o)
          {
            key:     check!(:key,     o, [Symbol, nil]),
            getter:  check!(:getter,  o, [:private, nil]),
            setter:  check!(:setter,  o, [:private, nil]),
            private: check!(:private, o, [true, false, :getter, :setter, nil])
          }
        end

        def create_field(name, owner, opts)
          field_klass.new(name, owner.to_s, **create_field_params(name, owner, opts))
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
      end
    end
  end
end
