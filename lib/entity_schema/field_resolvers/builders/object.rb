# frozen_string_literal: true

require_relative 'abstract'
require_relative '../object'

module EntitySchema
  module FieldResolvers
    # Abstract field
    module Builders
      class Object < Abstract
        include Singleton

        def call(name, schema, options)
          h = options.dup
          key_              = check_type! :key, h, [Symbol, NilClass]
          getter_           = check! :getter, h, [:private, nil]
          setter_           = check! :setter, h, [:private, nil]
          private_          = check! :private, h, [true, false, :getter, :setter, nil]
          mapper_           = check_ducktype! :mapper, h, [:call]
          map_to_           = check_type! :map_to, h, [Class]
          map_method_       = check_type! :map_method, h, [Symbol, NilClass]
          serialize_method_ = check_type! :serialize, h, [Symbol, NilClass]
          serializer_       = check_ducktype! :serializer, h, [:call]

          FieldResolvers::Object.new(
            name,
            schema,
            src_key:          first_of(key_, name),
            private_getter:   first_of(true_(getter_ == :private), true_(private_ == :getter), true_(private_), false),
            private_setter:   first_of(true_(setter_ == :private), true_(private_ == :setter), true_(private_), false),
            map_to:           map_to_,
            map_method:       map_method_ || :new,
            serialize_method: serialize_method_ || :to_h
          ).tap { guard_unknown_options!(h, name) }
        end
      end
    end
  end
end
