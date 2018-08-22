# frozen_string_literal: true

require 'singleton'

module EntitySchema
  module Fields
    module Contracts
      # TODO: doc
      # TODO: refactor overweight class
      # Builder is a Functional Object for creating Field using given options
      # In Abstract class defined interface and methods for processing any given options
      # ? may be extract options processing to another class
      class Abstract
        include Singleton

        def contract
          @contract ||= {}
        end

        def call(name, owner, raw_options, skip_unknown: false)
          check_contract_violation!(raw_options, name, owner, skip_unknown: skip_unknown)
          true
        end

        class << self
          def contract
            instance.contract
          end

          def call(*args, **options)
            instance.call(*args, **options)
          end

          def title
            to_s.match('::([A-Z][A-z]+)$')[1].downcase
          end
        end

        private

        attr_reader :options, :owner, :name

        def check_contract_violation!(options, name, owner, skip_unknown:)
          options.each do |key, value|
            contract.key?(key) || skip_unknown || raise_unknown!(key, value, name, owner)

            rules = contract[key]
            next if Array(rules[:eq]).any?         { |expectation| expectation == value }
            next if Array(rules[:type]).any?       { |type| value.is_a?(type) }
            next if Array(rules[:respond_to]).any? { |meth| value.respond_to?(meth) }
            raise_unexpected_value(rules, key, value)
          end
        end

        def raise_unknown!(key, value, name, owner)
          raise "Unknown option `#{key.inspect} => #{value.inspect}` given to " \
                "`#{title(owner)} :#{name}`\n" \
                "  Known options: #{contract.keys}"
        end

        def raise_unexpected_value(rules, key, value)
          msg  = "Unexpected option value `#{value.inspect}` of option `#{key.inspect}`. \n" \
                 '  Expected to:'
          msgs = []
          msgs << "\n    be equal to the one of #{rules[:eq]}" if rules.key?(:eq)
          msgs << "\n    be one of #{rules[:type]}" if rules.key?(:ty)
          msgs << "\n    respond to one of the methods #{rules[:respond_to]}"
          raise TypeError, (msg + msgs * ' OR')
        end

        def title(owner)
          "#{owner}.#{self.class.title}"
        end
      end
    end
  end
end
