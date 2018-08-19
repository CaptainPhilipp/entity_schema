# frozen_string_literal: true

require_relative '../property'

module EntitySchema
  module Fields
    # Abstract field
    module Builders
      class Abstract
        include Singleton

        def self.call(*args)
          instance.call(*args)
        end

        def call(name, schema, options)
          options = options.dup
          opts = extract_options(options)
          guard_unknown_options!(options, name)
          create_field(name, schema, opts)
        end

        private

        def extract_options(h)
          {
            key:              check!(:key, h, [Symbol, nil]),
            getter:           check!(:getter, h, [:private, nil]),
            setter:           check!(:setter, h, [:private, nil]),
            private:          check!(:private, h, [true, false, :getter, :setter, nil])
          }
        end

        def create_field(name, schema, opts)
          field_klass.new(name, schema, **create_field_params(opts, name))
        end

        def create_field_params(o, name)
          {
            src_key:          first_of(o[:key], name),
            private_getter:   first_of(true_(o[:getter] == :private), true_(o[:private] == :getter), true_(o[:private]), false),
            private_setter:   first_of(true_(o[:setter] == :private), true_(o[:private] == :setter), true_(o[:private]), false)
          }
        end

        def field_klass
          raise NotImplementedError
        end

        # Helpers

        def check!(key, h, allowed)
          value = h.delete(key)
          return value if allowed.any? do |v|
            v.is_a?(Class) ? value.is_a?(v) : value == v
          end
          raise ArgumentError, "option `#{key}:` must be in #{allowed}, but '#{value.inspect}'"
        end

        def check_ducktype!(key, h, methods)
          value = h.delete(key)
          return value if value.nil? || methods.all? { |m| value.respond_to?(m) }
          raise ArgumentError, "option `#{key}:` (#{value.inspect}) must respond to #{methods}"
        end

        def first_of(*alternatives)
          alternatives.compact.first
        end

        def true_(value)
          value == true ? true : nil
        end

        def not_bool(value)
          case value
          when true, false then nil
          else value
          end
        end

        def to_bool(value)
          value ? true : false
        end

        def guard_unknown_options!(opts, name)
          raise "Unknown options given to `#{name}:` #{opts.inspect}" if opts.any?
        end
      end
    end
  end
end
