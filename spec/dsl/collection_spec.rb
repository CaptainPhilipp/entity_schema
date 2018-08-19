# frozen_string_literal: true

require 'ostruct'

RSpec.describe 'EntitySchema collection' do
  CustomStruct = Struct.new(:a, :b, keyword_init: true) do
    def self.custom_new(input)
      new(input).tap do |n|
        n.instance_variable_set(:@custom_new_called, true)
      end
    end

    def custom_new_called?
      @custom_new_called || false
    end

    alias_method :old_to_h, :to_h

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

      collection :normal,          map_to: OpenStruct
      collection :map_method,      map_to: CustomStruct, map_method: :custom_new
      collection :serialize,       map_to: CustomStruct, serialize: :serialize
      collection :key_object_key,  map_to: OpenStruct, key: :object_key
      collection :private_true,    map_to: OpenStruct, private: true
      has_many   :has_many,        map_to: OpenStruct

      def self.serialize(input)
        input.to_h
      end
    end
  end

  let(:entity) do
    entity_klass.new(
      normal:       [a: 'a'],
      map_method:   [a: 'b'],
      serialize:    [{ a: 'c' }, { b: 'd' }],
      object_key:   [a: 'e'],
      has_many:     [a: 'f'],
      private_true: [a: 'g']
    )
  end

  describe 'without options' do
    it { expect(entity.normal).to                       eq [struct(a: 'a')] }
    it { expect { entity.normal = [a: 'changed'] }.to   change { entity[:normal] }.from([struct(a: 'a')]).to([struct(a: 'changed')]) }
    it { expect(entity[:normal]).to                     eq [struct(a: 'a')] }
    it { expect { entity[:normal] = [a: 'changed'] }.to change { entity.normal }.from([struct(a: 'a')]).to([struct(a: 'changed')]) }
    it { expect(entity.to_h[:normal]).to                eq([a: 'a']) }
  end

  describe 'with `map_method:` option' do
    it { expect(entity.map_method.first.custom_new_called?).to be true }
    it { expect(entity.map_method).to                          eq [custom(a: 'b')] }
  end

  describe 'with `serialize:` option' do
    before { entity.serialize } # lazy mapping

    it { expect(entity.to_h[:serialize]).to eq [{ 'a' => 'c', 'b' => nil }, { 'a' => nil, 'b' => 'd' }] }
  end

  describe 'with `key:` option' do
    it { expect(entity.key_object_key).to                       eq [struct(a: 'e')] }
    it { expect { entity.key_object_key = [a: 'changed'] }.to   change { entity[:key_object_key] }.from([struct(a: 'e')]).to([struct(a: 'changed')]) }
    it { expect(entity[:key_object_key]).to                     eq [struct(a: 'e')] }
    it { expect { entity[:key_object_key] = [a: 'changed'] }.to change { entity.key_object_key }.from([struct(a: 'e')]).to([struct(a: 'changed')]) }
    it { expect(entity.to_h[:object_key]).to                    eq([a: 'e']) }
  end

  describe 'has_many, without options' do
    it { expect(entity.has_many).to                       eq [struct(a: 'f')] }
    it { expect { entity.has_many = [a: 'changed'] }.to   change { entity[:has_many] }.from([struct(a: 'f')]).to([struct(a: 'changed')]) }
    it { expect(entity[:has_many]).to                     eq [struct(a: 'f')] }
    it { expect { entity[:has_many] = [a: 'changed'] }.to change { entity.has_many }.from([struct(a: 'f')]).to([struct(a: 'changed')]) }
    it { expect(entity.to_h[:has_many]).to                eq([a: 'f']) }
  end

  describe 'with `private: true` option' do
    it { expect { entity.private_true }.to                            raise_error(NoMethodError) }
    it { expect { entity.private_true = 'changed' }.to                raise_error(NoMethodError) }
    it { expect { entity[:private_true] }.to                          raise_error(NameError, 'Private Getter called for field `private_true` in `Entity`') }
    it { expect { entity[:private_true] = 'changed' }.to              raise_error(NameError, 'Private Setter called for field `private_true` in `Entity`') }
    it { expect(entity.send(:private_true)).to                        eq [struct(a: 'g')] }
    it { expect { entity.send(:private_true=, [struct(a: 'gg')]) }.to change { entity.to_h[:private_true] }.from([a: 'g']).to([a: 'gg']) }
    it { expect(entity.to_h[:private_true]).to                        eq([a: 'g']) }
  end

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
