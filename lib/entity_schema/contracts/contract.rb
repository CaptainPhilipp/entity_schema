# frozen_string_literal: true

module EntitySchema
  module Contracts
    # Check data with strict contract, described with Hash-based DSL
    class Contract
      class << self
        def build(*arguments_arr)
          params      = arguments_arr.to_a
          options     = params.last.is_a?(Hash) ? params.pop : {}
          new(to_params_hash(params).merge(options))
        end

        def to_params_hash(arr)
          arr.each_with_object({}).with_index do |(value, params), i|
            params["argument #{i + 1}"] = value
          end
        end
      end

      def initialize(rules)
        @rules = rules.dup
        @rules.each_value { |rule| rule.transform_values! { |v| v.nil? ? [nil] : Array(v) } }
        @rules.each(&:freeze).freeze
        freeze
      end

      def +(other)
        args        = other.to_a
        options     = args.last.is_a?(Hash) ? args.pop : {}
        other_rules = to_params_hash(args).merge(options)
        merge(rules.merge(other_rules))
      end

      def merge(other)
        other_rules = other.to_h
        self.class.new(rules.merge(other_rules))
      end

      def call(*params, skip_unknown: false, **options) # rubocop:disable Metrics/AbcSize
        keyvalue = to_params_hash(params).merge(options)
        keyvalue.each do |key, value|
          rules.key?(key) || skip_unknown || raise_unknown!(key, value)

          r = rules[key]
          next if r[:eq]&.any?         { |expectation| expectation == value }
          next if r[:type]&.any?       { |type| value.is_a?(type) }
          next if r[:respond_to]&.any? { |meth| value.respond_to?(meth) }
          raise_unexpected_value(r, key, value)
        end
        true
      end

      def to_h
        rules
      end

      def to_a
        params, options = to_arguments(rules)
        params << options
      end

      private

      attr_reader :rules

      def to_params_hash(a)
        self.class.to_params_hash(a)
      end

      def to_arguments(hash)
        arr = []
        hash = hash.dup
        hash.each_key do |k|
          arr << hash.delete(k) if k.is_a?(String) && k.start_with?('argument ')
        end
        [arr, hash]
      end

      def raise_unknown!(key, value)
        raise "Unknown option `#{key.inspect} => #{value.inspect}` given." \
              "  Known options: #{rules.keys}"
      end

      # rubocop:disable Metrics/LineLength
      def raise_unexpected_value(rules, key, value) # rubocop:disable Metrics/AbcSize
        msg  = "Unexpected #{key.inspect} value `#{value.inspect}`. \n" \
               '  Expected to:'
        msgs = []
        msgs << "\n    be equal to the one of: #{rules[:eq]&.map(&:inspect)}" if rules.key?(:eq)
        msgs << "\n    be one of: #{rules[:type]}" if rules[:type]
        msgs << "\n    respond to one of the methods: #{rules[:respond_to]}" if rules.key?(:respond_to)
        raise TypeError, (msg + msgs * ' OR')
      end
      # rubocop:enable Metrics/LineLength
    end
  end
end
