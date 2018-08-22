# frozen_string_literal: true

module EntitySchema
  module Fields
    module Specifications
      # TODO: doc
      # TODO: refactor overweight class
      # Builder is a Functional Object for creating Field using given options
      # In Abstract class defined interface and methods for processing any given options
      # ? may be extract options processing to another class
      class Abstract
        def self.title
          to_s.match('::([A-Z][A-z]+)$')[1].downcase
        end

        def initialize(name, owner, raw_options)
          @owner            = owner
          @contract_options = contract_options!(raw_options)
          guard_unknown_options!(raw_options, name)

          @options = transform_options(name, @contract_options)
        end

        def [](key)
          options[key]
        end

        def to_h
          options
        end

        private

        attr_reader :options, :owner

        # :nocov:
        def contract_options!(_raw_options)
          Hash.new { |_, key| raise NameError, "Unknown raw option #{key.inspect}" }
        end
        # :nocov:

        # :nocov:
        def transform_options(_name, _options)
          Hash.new { |_, key| raise NameError, "Unknown option #{key.inspect}" }
        end
        # :nocov:

        def contract!(key, options, allowed, allowed_methods = [])
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
          return if opts.empty?
          raise "Unknown options #{opts.inspect} given to `#{title} :#{name}`\n" \
                "  Known options: #{@contract_options.keys}"
        end

        def title
          "#{@owner}.#{self.class.title}"
        end
      end
    end
  end
end
