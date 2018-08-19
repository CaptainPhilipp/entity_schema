# frozen_string_literal: true

require_relative 'abstract'
require_relative '../object'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class Object < Abstract
        def call(name, schema, options)
          h = options.dup
          key_              = check! :key, h, [Symbol, nil]
          getter_           = check! :getter, h, [:private, nil]
          setter_           = check! :setter, h, [:private, nil]
          private_          = check! :private, h, [true, false, :getter, :setter, nil]
          mapper_           = check_ducktype! :mapper, h, [:call]
          map_to_           = check! :map_to, h, [Class]
          map_method_       = check! :map_method, h, [Symbol, nil]
          serialize_method_ = check! :serialize, h, [Symbol, nil]
          serializer_       = check_ducktype! :serializer, h, [:call]
          guard_unknown_options!(h, name)

          field_klass.new(
            name,
            schema,
            src_key:          first_of(key_, name),
            private_getter:   first_of(true_(getter_ == :private), true_(private_ == :getter), true_(private_), false),
            private_setter:   first_of(true_(setter_ == :private), true_(private_ == :setter), true_(private_), false),
            map_to:           map_to_,
            map_method:       map_method_ || :new,
            serialize_method: serialize_method_ || :to_h,
          )
        end
      end

      private

      def field_klass
        Fields::Object
      end
    end
  end
end
