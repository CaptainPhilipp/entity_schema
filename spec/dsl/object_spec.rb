# frozen_string_literal: true

require 'ostruct'

RSpec.describe 'EntitySchema object' do
  ValueObject = Struct.new(:a, :b, keyword_init: true) do
    def self.custom_new(input)
      new(input).tap do |n|
        n.instance_variable_set(:@custom_new_called, true)
      end
    end

    def custom_new_called?
      @custom_new_called || false
    end

    alias_method :old_to_h, :to_h

    def transformed_serialize
      old_to_h.transform_keys(&:to_s)
    end
  end

  let(:entity_klass) do
    Class.new do
      extend EntitySchema

      def self.to_s
        'Entity'
      end

      object :normal,          OpenStruct
      object :map_method,      ValueObject, map_method: :custom_new
      object :serialize,       'ValueObject', serialize: :transformed_serialize
      object :key_object_key,  :OpenStruct, key: :object_key
      object :private_true,    OpenStruct, private: true
      has_one :has_one,        OpenStruct

      def self.serialize(input)
        input.to_h
      end
    end
  end

  let(:entity) do
    entity_klass.new(
      normal:       { a: 'a' },
      map_method:   { a: 'b' },
      serialize:    { a: 'c', b: 'd' },
      object_key:   { a: 'e' },
      has_one:      { a: 'f' },
      private_true: { a: 'g' }
    )
  end

  describe 'without options' do
    it { expect(entity.normal).to                         eq struct(a: 'a') }
    it { expect { entity.normal = { a: 'changed' } }.to   change { entity[:normal] }.from(struct(a: 'a')).to(struct(a: 'changed')) }
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

  describe 'with `key:` option' do
    it { expect(entity.key_object_key).to                         eq struct(a: 'e') }
    it { expect { entity.key_object_key = { a: 'changed' } }.to   change { entity[:key_object_key] }.from(struct(a: 'e')).to(struct(a: 'changed')) }
    it { expect(entity[:key_object_key]).to                       eq struct(a: 'e') }
    it { expect { entity[:key_object_key] = { a: 'changed' } }.to change { entity.key_object_key }.from(struct(a: 'e')).to(struct(a: 'changed')) }
    it { expect(entity.to_h[:object_key]).to                      eq(a: 'e') }
  end

  describe 'has_one, without options' do
    it { expect(entity.has_one).to                         eq struct(a: 'f') }
    it { expect { entity.has_one = { a: 'changed' } }.to   change { entity[:has_one] }.from(struct(a: 'f')).to(struct(a: 'changed')) }
    it { expect(entity[:has_one]).to                       eq struct(a: 'f') }
    it { expect { entity[:has_one] = { a: 'changed' } }.to change { entity.has_one }.from(struct(a: 'f')).to(struct(a: 'changed')) }
    it { expect(entity.to_h[:has_one]).to                  eq(a: 'f') }
  end

  describe 'with `private: true` option' do
    it { expect { entity.private_true }.to                          raise_error(NoMethodError) }
    it { expect { entity.private_true = 'changed' }.to              raise_error(NoMethodError) }
    it { expect { entity[:private_true] }.to                        raise_error(NameError, 'Private Getter called for field `private_true` of `Entity`') }
    it { expect { entity[:private_true] = 'changed' }.to            raise_error(NameError, 'Private Setter called for field `private_true` of `Entity`') }
    it { expect(entity.send(:private_true)).to                      eq struct(a: 'g') }
    it { expect { entity.send(:private_true=, struct(a: 'gg')) }.to change { entity.to_h[:private_true] }.from(a: 'g').to(a: 'gg') }
    it { expect(entity.to_h[:private_true]).to                      eq(a: 'g') }
  end

  def struct(*opts)
    OpenStruct.new(*opts)
  end

  def custom(*opts)
    ValueObject.new(*opts)
  end

  def vobject(*opts)
    ValueObject.new(*opts)
  end
end
