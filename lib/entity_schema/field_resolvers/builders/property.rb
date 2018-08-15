# frozen_string_literal: true

require_relative '../property'


module EntitySchema
  module FieldResolvers
    # Abstract field
    module Builders
      class Property
        include Singleton

        def call(name, schema, options)
          o = options.dup
          is_hidden  = bool(o.delete(:hidden))
          is_private = bool(o.delete(:private))

          FieldResolvers::Property.new(
            name,
            schema,
            src_key:        o.delete(:key)                  || name,
            private_getter: bool(o.delete(:private_getter)) || is_private,
            private_setter: bool(o.delete(:private_setter)) || is_private,
            get_enabled:    bool(o.delete(:getter))         || !is_hidden,
            set_enabled:    bool(o.delete(:setter))         || !is_hidden,
          ).tap { guard_unknown_options!(o) }
        end

        private

        def bool(value)
          value ? true : false
        end

        def sub(value, **opts)
          value == true ? opts[:true] : value
        end

        def guard_unknown_options!(opts)
          raise "Unknown options given: #{opts.inspect}" if opts.any?
        end
      end
    end
  end
end
