# frozen_string_literal: true

require_relative '../property'


module EntitySchema
  module FieldResolvers
    # Abstract field
    module Builders
      class Property
        include Singleton

        # TODO: refactor this shit
        def call(name, schema, options)
          o = options.dup
          is_hidden  = bool! o.delete(:hidden)
          is_private = bool! o.delete(:private)

          FieldResolvers::Property.new(
            name,
            schema,
            src_key:        src_key!(o, :key,                     default: name),
            private_getter: private!(o, :private_getter, :getter, default: is_private),
            private_setter: private!(o, :private_setter, :setter, default: is_private),
            get_enabled:    enabled!(o, :getter,                  default: !is_hidden),
            set_enabled:    enabled!(o, :setter,                  default: !is_hidden),
            predicate:      o.delete(:predicate)
          ).tap { guard_unknown_options!(o) }
        end

        private

        def src_key!(options, key, default:)
          value = options.delete(key)
          sym! default(value, default)
        end

        def private!(options, key, key2, default:)
          value = options.delete(key)
          value = options[key2] if value.nil?

          case value
          when :private then true
          when nil      then bool!(default)
          else               bool!(value)
          end
        end

        def enabled!(options, key, default:)
          value = options.delete(key)
          bool(default(value, default))
        end

        def bool!(value)
          case value
          when true, false, nil then value
          else raise ArgumentError, "Expected to receive (true|false|nil), not #{value.inspect}"
          end
        end

        def sym!(value)
          return value if value.nil? || value.is_a?(Symbol)
          raise ArgumentError, "Expected to receive Symbol, not #{value.inspect}"
        end

        def default(value, default)
          value.nil? ? default : value
        end

        def bool(value)
          value ? true : false
        end

        def guard_unknown_options!(opts)
          raise "Unknown options given: #{opts.inspect}" if opts.any?
        end
      end
    end
  end
end
