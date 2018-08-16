# frozen_string_literal: true

require 'ostruct'

RSpec.describe 'EntitySchema.object()' do
  let(:entity_klass) do
    CustomStruct ||= Struct.new(:x) do
      def self.wrap(input)
        input.is_a?(self) ? input : new(input)
      end

      def serializable_hash
        to_h.transform_keys(&:to_s)
      end
    end

    Class.new do
      extend EntitySchema

      def self.to_s
        'Entity'
      end

      object :normal,         map_to: OpenStruct
      object :map_method,     map_to: CustomStruct, map_method: :wrap
      object :serialize,      map_to: CustomStruct, serialize: :serializable_hash
      object :key_object_key, map_to: OpenStruct, key: :object_key
      object :getter_private, map_to: OpenStruct, getter: :private
      object :setter_private, map_to: OpenStruct, setter: :private
      object :private_getter, map_to: OpenStruct, private: :getter
      object :private_setter, map_to: OpenStruct, private: :setter
      object :private_true,   map_to: OpenStruct, private: true
      object :mapper,         map_to: OpenStruct, mapper: ->(x) { x.to_h }
      object :serializer,     map_to: OpenStruct, serializer: :serialize_.to_proc
      has_one :has_one,       map_to: OpenStruct

      def self.serialize(input)
        input.to_h
      end
    end
  end

  let(:entity) do
    entity_klass.new(
      normal: { a: 'a' }
    )
  end

  describe 'without options' do
    it { expect(entity.normal).to                  eq ostruct(a: 'a') }
    it { expect { entity.normal   = { a: 'changed' } }.to change { entity[:normal] }.from(ostruct(a: 'a')).to(ostruct(a: 'changed')) }
    it { expect(entity[:normal]).to                eq ostruct(a: 'a') }
    it { expect { entity[:normal] = { a: 'changed' } }.to change { entity.normal }.from(ostruct(a: 'a')).to(ostruct(a: 'changed')) }
    it { expect(entity.to_h[:normal]).to           eq a: 'a' }
  end

  describe 'with `map_method:` option'
  describe 'with `serialize:` option'
  describe 'with `key:` option'
  describe 'with `getter: :private` option'
  describe 'with `setter: :private` option'
  describe 'with `private: :setter` option'
  describe 'with `private: :getter` option'
  describe 'with `private: true` option'
  describe 'with `mapper:` option'
  describe 'with `serializer:` option'
  describe 'has_one, without options'

  def ostruct(*opts)
    OpenStruct.new(*opts)
  end
end
