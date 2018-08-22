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

        def initialize(name, owner, raw_options, skip_unknown: false)
          @name  = name
          @owner = owner
          @skip_unknown = skip_unknown
          contract!(raw_options)
          @options = transform_options(raw_options)
        end

        def self.contract
          @contract ||= {}
        end

        def [](key)
          options.fetch(key, nil)
        end

        def to_h
          options
        end

        private

        attr_reader :options, :owner, :name

        def contract!(options)
          options.each do |key, value|
            raise_unknown_option(key, value) unless self.class.contract.key?(key) || @skip_unknown

            rules = self.class.contract[key]
            next if rules[:eq]&.any?         { |expectation| expectation == value }
            next if rules[:type]&.any?       { |type| value.is_a?(type) }
            next if rules[:respond_to]&.any? { |meth| value.respond_to?(meth) }
            raise_unexpected_option_value(rules, key, value)
          end
        end

        # :nocov:
        def transform_options(_options)
          Hash.new { |_, k| raise NameError, "Unknown option for transformation #{k.inspect}" }
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

        def raise_unknown_option(key, value)
          raise "Unknown option `#{key.inspect} => #{value.inspect}` given to `#{title} :#{name}`\n" \
                "  Known options: #{contract.keys}"
        end

        def raise_unexpected_option_value(rules, key, value)
          msg  = "Unexpected option value `#{value.inspect}` of option `#{key.inspect}`."
          msgs = []
          msgs << "\n  Expected to be equal to one of: #{rules[:eq]}" if rules[:eq]&.any?
          msgs << "\n  Expected to be one of: #{rules[:type]}" if rules[:type]&.any?
          msgs << "\n  Expected to respond to one of method: #{rules[:respond_to]}" if rules[:respond_to]&.any?
          raise TypeError, (msg + msgs * ' OR')
        end

        def title
          "#{@owner}.#{self.class.title}"
        end
      end
    end
  end
end
