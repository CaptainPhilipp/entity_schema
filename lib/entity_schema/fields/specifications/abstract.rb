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
        def initialize(name, owner, raw_options)
          @name  = name
          @owner = owner
          @options = transform_options(raw_options)
        end

        def [](key)
          options.fetch(key, nil)
        end

        def to_h
          options.dup
        end

        private

        attr_reader :options, :owner, :name

        # :nocov:
        def transform_options(_options)
          Hash.new { |_, k| raise "Gem works wrong: not transformed option #{k.inspect}" }
        end
        # :nocov:

        def find(*alternatives)
          alternatives.compact.first
        end

        def callable(subject)
          subject if subject.respond_to?(:call)
        end

        def owner_meth(option)
          return unless option.is_a?(Symbol)
          owner.method(option)
        end

        def truth(subject)
          subject == true ? true : nil
        end

        def to_bool(subject)
          subject ? true : false
        end
      end
    end
  end
end
