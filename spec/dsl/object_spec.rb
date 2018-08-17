# frozen_string_literal: true

require 'ostruct'

RSpec.describe 'EntitySchema.object' do
  CustomStruct = Struct.new(:a, :b, keyword_init: true) do
    def self.custom_new(input)
      new(input).tap do |n|
        n.instance_variable_set(:@custom_new_called, true)
      end
    end

    def custom_new_called?
      @custom_new_called || false
    end

    alias old_to_h to_h

    def serialize
      old_to_h.transform_keys(&:to_s)
    end
  end

  let(:entity_klass) do
    Class.new do
      extend EntitySchema

      def self.to_s
        'Entity'
      end

      object :normal,          map_to: OpenStruct
      object :map_method,      map_to: CustomStruct, map_method: :custom_new
      object :serialize,       map_to: CustomStruct, serialize: :serialize
      object :key_object_key,  map_to: OpenStruct, key: :object_key
      object :private_true,    map_to: OpenStruct, private: true
      object :private_getter,  map_to: OpenStruct, private: :getter
      object :private_setter,  map_to: OpenStruct, private: :setter
      object :getter_private,  map_to: OpenStruct, getter: :private
      object :setter_private,  map_to: OpenStruct, setter: :private
      object :mapper,          map_to: OpenStruct, mapper: ->(x) { x.to_h }
      object :serializer,      map_to: OpenStruct, serializer: :serialize_.to_proc
      has_one :has_one,        map_to: OpenStruct

      def self.serialize(input)
        input.to_h
      end
    end
  end

  let(:entity) do
    entity_klass.new(
      normal:     { a: 'a' },
      map_method: { a: 'b' },
      serialize:  { a: 'c', b: 'd' },
      object_key: { a: 'e' },
      has_one:    { a: 'f' }
    )
  end

  describe 'without options' do
    it { expect(entity.normal).to                         eq struct(a: 'a') }
    it { expect { entity.normal   = { a: 'changed' } }.to change { entity[:normal] }.from(struct(a: 'a')).to(struct(a: 'changed')) }
    it { expect(entity[:normal]).to                       eq struct(a: 'a') }
    it { expect { entity[:normal] = { a: 'changed' } }.to change { entity.normal }.from(struct(a: 'a')).to(struct(a: 'changed')) }
    it { expect(entity.to_h[:normal]).to                  eq(a: 'a') }
  end

  describe 'with `map_method:` option' do
    it { expect(entity.map_method.custom_new_called?).to be true }
    it { expect(entity.map_method).to                    eq custom(a: 'b') }
  end

  describe 'with `serialize:` option' do
    before { entity.serialize } # lazy mapping

    it { expect(entity.to_h[:serialize]).to eq 'a' => 'c', 'b' => 'd' }
  end

  describe 'with `flat_serialize:` and `flat_keys:` option' do
    before { skip 'TODO' }
    it { expect(entity.to_h).to include serialize_a: 'd', serialize_b: 'e' }
  end

  describe 'with `key:` option' do
    it { expect(entity.key_object_key).to                         eq struct(a: 'e') }
    it { expect { entity.key_object_key   = { a: 'changed' } }.to change { entity[:key_object_key] }.from(struct(a: 'e')).to(struct(a: 'changed')) }
    it { expect(entity[:key_object_key]).to                       eq struct(a: 'e') }
    it { expect { entity[:key_object_key] = { a: 'changed' } }.to change { entity.key_object_key }.from(struct(a: 'e')).to(struct(a: 'changed')) }
    it { expect(entity.to_h[:object_key]).to                      eq(a: 'e') }
  end

  describe 'has_one, without options' do
    it { expect(entity.has_one).to                         eq struct(a: 'f') }
    it { expect { entity.has_one   = { a: 'changed' } }.to change { entity[:has_one] }.from(struct(a: 'f')).to(struct(a: 'changed')) }
    it { expect(entity[:has_one]).to                       eq struct(a: 'f') }
    it { expect { entity[:has_one] = { a: 'changed' } }.to change { entity.has_one }.from(struct(a: 'f')).to(struct(a: 'changed')) }
    it { expect(entity.to_h[:has_one]).to                  eq(a: 'f') }
  end

  describe 'with `mapper:` option'
  describe 'with `serializer:` option'
  describe 'with `getter: :private` option'
  describe 'with `setter: :private` option'
  describe 'with `private: :setter` option'
  describe 'with `private: :getter` option'
  describe 'with `private: true` option'

  def struct(*opts)
    OpenStruct.new(*opts)
  end

  def custom(*opts)
    CustomStruct.new(*opts)
  end

  def vobject(*opts)
    ValueObject.new(*opts)
  end
end
