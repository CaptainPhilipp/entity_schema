# frozen_string_literal: true

require_relative '../property'

module EntitySchema
  module FieldResolvers
    # Abstract field
    module Builders
      class Abstract
        include Singleton

        def self.call(*args)
          instance.call(*args)
        end

        private

        def check!(key, h, allowed)
          value = h.delete(key)
          return value if allowed.include?(value)
          raise ArgumentError, "option `#{key}:` must be in #{allowed}, but '#{value}'"
        end

        def check_type!(key, h, types)
          value = h.delete(key)
          return value if types.any? { |t| value.is_a?(t) }
          raise ArgumentError, "option `#{key}:` must has one of types #{types}, but is a #{value.class}"
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
