# frozen_string_literal: true

require_relative '../property'


module EntitySchema
  module FieldResolvers
    # Abstract field
    module Builders
      class Property
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

        private

        def check_type!(key, h, types)
          value = h.delete(key)
          return value if types.any? { |t| value.is_a?(t) }
          raise ArgumentError, ":key option must be a #{types}, not #{value.class}"
        end

        def check!(key, h, allowed)
          value = h.delete(key)
          return value if allowed.include?(value)
          raise ArgumentError, ":#{title} option must be in #{allowed}, but '#{value}'"
        end

        def first_of(*alternatives)
          alternatives.compact.first
        end

        def true_(value)
          value == true ? true : nil
        end

        def to_bool(value)
          value ? true : false
        end

        def guard_unknown_options!(opts, name)
          raise "Unknown options given to `:#{name}`: #{opts.inspect}" if opts.any?
        end
      end
    end
  end
end
