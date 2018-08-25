# frozen_string_literal: true

require 'singleton'

module EntitySchema
  module Transformers
    # Transform raw valid options to usefull options
    class Abstract
      include Singleton

      def self.call(*args)
        instance.call(*args)
      end

      def call(name, owner_name, type, raw_options)
        transform_options(name: name, owner_name: owner_name, map_to: type, **raw_options)
      end

      private

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
