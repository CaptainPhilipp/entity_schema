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
