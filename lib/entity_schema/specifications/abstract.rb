# frozen_string_literal: true

module EntitySchema
  module Specifications
    # Transform raw valid options to usefull options
    class Abstract
      def initialize(name, owner_name, raw_options)
        @options = transform_options(name: name,
                                     owner_name: owner_name,
                                     **raw_options)
      end

      def [](key)
        options.fetch(key, nil)
      end

      def to_h
        options.dup
      end

      def method_missing(key, *_args, **_opts)
        return options[key] if options.key?(key)
        root = without_predicate(key)
        return options[root] if bool_key?(root)
        super
      end

      def respond_to_missing?(key)
        options.key?(key) || bool_key?(without_predicate(key))
      end

      private

      attr_reader :options

      # Hook for ancestors
      def transform_options(_options)
        new_strict_hash
      end

      def bool_key?(key)
        [true, false].include? options.fetch(key, nil)
      end

      def without_predicate(key)
        key.to_s.delete('?').to_sym
      end

      def new_strict_hash
        Hash.new do |h, k|
          raise "Gem works wrong: missed option `#{k.inspect}` called. Options is: #{h.keys}"
        end
      end

      def find(*alternatives)
        alternatives.compact.first
      end

      # eql(hash, a: 1, b: [1, 2, :value])
      def eql(input, pairs)
        pairs.each do |k, values|
          Array(values).each do |v|
            return true if input[k] == v
          end
        end
        nil
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
