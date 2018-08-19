# frozen_string_literal: true

require_relative 'abstract'
require_relative '../property'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class Property < Abstract
        include Singleton

        def call(name, schema, options)
          h = options.dup
          key_       = check! :key, h, [Symbol, nil]
          getter_    = check! :getter, h, [:private, nil]
          setter_    = check! :setter, h, [:private, nil]
          private_   = check! :private, h, [true, false, :getter, :setter, nil]
          predicate_ = check! :predicate, h, [true, false, nil]

          Fields::Property.new(
            name,
            schema,
            src_key:        first_of(key_, name),
            private_getter: first_of(true_(getter_ == :private), true_(private_ == :getter), true_(private_), false),
            private_setter: first_of(true_(setter_ == :private), true_(private_ == :setter), true_(private_), false),
            predicate:      to_bool(predicate_)
          ).tap { guard_unknown_options!(h, name) }
        end
      end
    end
  end
end
