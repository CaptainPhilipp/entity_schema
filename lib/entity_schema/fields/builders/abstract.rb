# frozen_string_literal: true

require 'singleton'
require_relative '../property'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      # Todo: refactor overweight class:
      #   Responsibilities:
      #     - options with strict contract and meaningfull exceptions,
      #     - options transformation,
      #     - building object,
      #       building default mappers/serializers
      #   refactor to Specification, Builder,
      #         or to ParamsObject, Specification, Builder
      class Abstract
        include Singleton

        def self.call(*args)
          instance.call(*args)
        end

        def call(name, owner, options)
          opts = extract_options(options)
          guard_unknown_options!(options, name)
          create_field(name, owner, opts)
        end

        private

        def extract_options(o)
          {
            key:     check!(:key,     o, [Symbol, nil]),
            getter:  check!(:getter,  o, [:private, nil]),
            setter:  check!(:setter,  o, [:private, nil]),
            private: check!(:private, o, [true, false, :getter, :setter, nil])
          }
        end

        def create_field(name, owner, opts)
          field_klass.new(name, owner.to_s, **create_field_params(name, owner, opts))
        end

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def create_field_params(name, _owner, o)
          {
            src_key:        find(o[:key], name),
            public_getter: !find(truth(o[:getter] == :private),
                                 truth(o[:private] == :getter),
                                 truth(o[:private]),
                                 false),
            public_setter: !find(truth(o[:setter] == :private),
                                 truth(o[:private] == :setter),
                                 truth(o[:private]),
                                 false)
          }
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

        # :nocov:
        def field_klass
          raise NotImplementedError
        end
        # :nocov:

        # Helpers

        def check!(key, options, allowed, allowed_methods = [])
          subject = options.delete(key)

          return subject if allowed.any? do |v|
            (v.is_a?(Class) ? subject.is_a?(v) : subject == v)
          end

          return subject if allowed_methods.any? { |m| subject.respond_to?(m) }

          raise ArgumentError, "option `#{key}:` must be in #{allowed}, but '#{subject.inspect}'"
        end

        def find(*alternatives)
          alternatives.compact.first
        end

        def callable(subject)
          subject if subject.respond_to?(:call)
        end

        def owner_meth(option, owner)
          return unless option.is_a?(Symbol)
          owner.method(option)
        end

        def truth(subject)
          subject == true ? true : nil
        end

        def to_bool(subject)
          subject ? true : false
        end

        def guard_unknown_options!(opts, name)
          raise "Unknown options given to `#{name}:` #{opts.inspect}" if opts.any?
        end
      end
    end
  end
end
