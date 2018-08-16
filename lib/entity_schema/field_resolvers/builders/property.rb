# frozen_string_literal: true

require_relative 'abstract'
require_relative '../property'

module EntitySchema
  module FieldResolvers
    # Abstract field
    module Builders
      class Property < Abstract
        include Singleton

        def call(name, schema, options)
          h = options.dup
          key_            = check_type! :key, h, [Symbol, NilClass]
          getter_         = check! :getter, h, [true, false, :private, nil]
          setter_         = check! :setter, h, [true, false, :private, nil]
          private_        = check! :private, h, [true, false, :getter, :setter, nil]
          predicate_      = check! :predicate, h, [true, false, nil]

          FieldResolvers::Property.new(
            name,
            schema,
            src_key:        first_of(key_, name),
            private_getter: first_of(true_(private_ == :getter), true_(getter_ == :private), true_(private_), false),
            private_setter: first_of(true_(private_ == :setter), true_(setter_ == :private), true_(private_), false),
            predicate:      to_bool(predicate_)
          ).tap { guard_unknown_options!(h, name) }
        end
      end
    end
  end
end
