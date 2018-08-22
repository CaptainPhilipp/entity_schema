# frozen_string_literal: true

require 'ostruct'

RSpec.describe 'EntitySchema belongs_to' do
  before { skip }

  RelatedObject = Struct.new(:id, :a, keyword_init: true) do
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

      belongs_to :normal,         map_to: OpenStruct
      belongs_to :normal2,        map_to: OpenStruct
      belongs_to :custom,         map_to: OpenStruct, fk: :custom_uid, pk: :uid
      belongs_to :map_method,     map_to: RelatedObject, map_method: :custom_new
      belongs_to :serialize,      map_to: RelatedObject, serialize: :serialize
      belongs_to :key_object_key, map_to: OpenStruct, key: :object_key
      belongs_to :private_true,   map_to: OpenStruct, private: true

      def self.serialize(input)
        input.to_h
      end
    end
  end

  let(:entity) do
    entity_klass.new(
      normal:       { id: 'a' },
      normal2_id:   'b',
      custom:       { uid: 'c' },
      map_method:   { id: 'd' },
      serialize:    { id: 'e', a: 'f' },
      object_key:   { id: 'g' },
      private_true: { id: 'h' }
    )
  end

  describe 'without options' do
    it { expect(entity.normal).to                          eq struct(id: 'a') }
    it { expect { entity.normal = { id: 'changed' } }.to   change { entity[:normal] }.from(struct(id: 'a')).to(struct(id: 'changed')) }
    it { expect(entity[:normal]).to                        eq struct(id: 'a') }
    it { expect { entity[:normal] = { id: 'changed' } }.to change { entity.normal }.from(struct(id: 'a')).to(struct(id: 'changed')) }
    it { expect(entity.to_h[:normal]).to                   eq(id: 'a') }

    context '(without foreign key)' do
      it { expect(entity.normal2).to                          be nil }
      it { expect { entity.normal2 = { id: 'changed' } }.to   change { entity[:normal2] }.from(nil).to(struct(id: 'changed')) }
      it { expect(entity[:normal2]).to                        be nil }
      it { expect { entity[:normal2] = { id: 'changed' } }.to change { entity.normal2 }.from(nil).to(struct(id: 'changed')) }
      it { expect(entity.to_h.key?(:normal2)).to              be false }
    end

    context '(foreign key)' do
      it { expect(entity.normal2_id).to                  eq 'b' }
      it { expect { entity.normal2_id = 'changed' }.to   change { entity[:normal2_id] }.from('b').to('changed') }
      it { expect(entity[:normal2_id]).to                eq 'b' }
      it { expect { entity[:normal2_id] = 'changed' }.to change { entity.normal2_id }.from('b').to('changed') }
      it { expect(entity.to_h[:normal2_id]).to           eq 'b' }
    end
  end

  describe 'when foreign key changed to another' do
    let(:change_fk) { entity.normal_id *= 2 }

    it { expect { change_fk }.to change { entity.normal }.to nil }
  end

  describe 'when foreign key changed to same' do
    let(:change_fk) { entity.normal_id = entity.normal.id }

    it { expect { change_fk }.not_to change { entity.normal } }
    it { expect { change_fk }.not_to change { entity.normal.object_id } }
  end

  describe 'when object changed to object with other id' do
    let(:change_pk) { entity.normal = struct(id: 'b') }

    it { expect { change_pk }.to change { entity.normal_id }.to('b') }
  end

  describe 'when object changed to object with same id' do
    let(:change_pk) { entity.normal = struct(id: entity.normal.id) }

    it { expect { change_pk }.not_to change { entity.normal_id } }
    it { expect { change_pk }.not_to change { entity.normal_id.object_id } }
  end

  describe 'with `map_method:` option' do
    it { expect(entity.map_method.custom_new_called?).to be true }
    it { expect(entity.map_method).to                    eq custom(id: 'd') }
  end

  describe 'with `serialize:` option' do
    before { entity.serialize } # lazy mapping

    it { expect(entity.to_h[:serialize]).to eq 'id' => 'e', 'a' => 'f' }
  end

  describe 'with `key:` option' do
    it { expect(entity.key_object_key).to                          eq struct(id: 'g') }
    it { expect { entity.key_object_key = { id: 'changed' } }.to change { entity[:key_object_key] }.from(struct(id: 'g')).to(struct(id: 'changed')) }
    it { expect(entity[:key_object_key]).to                        eq struct(id: 'g') }
    it { expect { entity[:key_object_key] = { id: 'changed' } }.to change { entity.key_object_key }.from(struct(id: 'g')).to(struct(id: 'changed')) }
    it { expect(entity.to_h[:object_key]).to                       eq(id: 'g') }
  end

  describe 'with `private: true` option' do
    it { expect { entity.private_true }.to                           raise_error(NoMethodError) }
    it { expect { entity.private_true = 'changed' }.to               raise_error(NoMethodError) }
    it { expect { entity[:private_true] }.to                         raise_error(NameError, 'Private Getter called for field `private_true` of `Entity`') }
    it { expect { entity[:private_true] = 'changed' }.to             raise_error(NameError, 'Private Setter called for field `private_true` of `Entity`') }
    it { expect(entity.send(:private_true)).to                       eq struct(id: 'h') }
    it { expect { entity.send(:private_true=, struct(id: 'gg')) }.to change { entity.to_h[:private_true] }.from(id: 'h').to(id: 'gg') }
    it { expect(entity.to_h[:private_true]).to                       eq(id: 'h') }
  end

  def struct(*opts)
    OpenStruct.new(*opts)
  end

  def custom(*opts)
    RelatedObject.new(*opts)
  end

  def vobject(*opts)
    ValueObject.new(*opts)
  end
end
