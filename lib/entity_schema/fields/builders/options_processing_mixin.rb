# frozen_string_literal: true

require 'singleton'

module EntitySchema
  module Fields
    module Builders
      # TODO: doc
      # TODO: refactor overweight class
      # Builder is a Functional Object for creating Field using given options
      # In Abstract class defined interface and methods for processing any given options
      # ? may be extract options processing to another class
      module OptionsProcessingMixin
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
