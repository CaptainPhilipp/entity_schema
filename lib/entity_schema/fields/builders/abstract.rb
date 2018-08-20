# frozen_string_literal: true

require 'singleton'
require_relative '../property'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      class Abstract
        include Singleton

        def self.call(*args)
          instance.call(*args)
        end

        def call(name, owner_name, options)
          options = options.dup
          opts = extract_options(options)
          guard_unknown_options!(options, name)
          create_field(name, owner_name, opts)
        end

        private

        def extract_options(o)
          {
            key:     check!(:key, o, [Symbol, nil]),
            getter:  check!(:getter, o, [:private, nil]),
            setter:  check!(:setter, o, [:private, nil]),
            private: check!(:private, o, [true, false, :getter, :setter, nil])
          }
        end

        def create_field(name, owner_name, opts)
          field_klass.new(name, owner_name, **create_field_params(opts, name))
        end

        # rubocop:disable Metrics/AbcSize:
        def create_field_params(o, name)
          {
            src_key:        first_of(o[:key], name),
            public_getter: !first_of(true_(o[:getter] == :private), true_(o[:private] == :getter), true_(o[:private]), false),
            public_setter: !first_of(true_(o[:setter] == :private), true_(o[:private] == :setter), true_(o[:private]), false)
          }
        end
        # rubocop:enable Metrics/AbcSize:

        # :nocov:
        def field_klass
          raise NotImplementedError
        end
        # :nocov:

        # Helpers

        # rubocop:disable Naming/UncommunicativeMethodParamName
        def check!(key, h, allowed)
          value = h.delete(key)
          return value if allowed.any? do |v|
            v.is_a?(Class) ? value.is_a?(v) : value == v
          end
          raise ArgumentError, "option `#{key}:` must be in #{allowed}, but '#{value.inspect}'"
        end
        # rubocop:enable Naming/UncommunicativeMethodParamName

        # rubocop:disable Naming/UncommunicativeMethodParamName
        def check_ducktype!(key, h, methods)
          value = h.delete(key)
          return value if value.nil? || methods.all? { |m| value.respond_to?(m) }
          raise ArgumentError, "option `#{key}:` (#{value.inspect}) must respond to #{methods}"
        end
        # rubocop:enable Naming/UncommunicativeMethodParamName

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
