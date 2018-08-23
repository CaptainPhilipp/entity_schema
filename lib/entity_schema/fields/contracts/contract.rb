# frozen_string_literal: true

module EntitySchema
  module Fields
    module Contracts
      class Contract
        def initialize(rules)
          @rules = rules
        end

        def +(other)
          self.class.new(rules.merge(other.to_h))
        end

        def call(raw_options, skip_unknown: false)
          raw_options.each do |key, value|
            rules.key?(key) || skip_unknown || raise_unknown!(key, value)

            r = rules[key]
            next if Array(r[:eq]).any?         { |expectation| expectation == value }
            next if Array(r[:type]).any?       { |type| value.is_a?(type) }
            next if Array(r[:respond_to]).any? { |meth| value.respond_to?(meth) }
            raise_unexpected_value(r, key, value)
          end
          true
        end

        def to_h
          rules
        end

        private

        attr_reader :rules

        def raise_unknown!(key, value)
          raise "Unknown option `#{key.inspect} => #{value.inspect}` given." \
                "  Known options: #{rules.keys}"
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
      end
    end
  end
end
