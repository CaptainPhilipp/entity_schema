# frozen_string_literal: true

require 'ostruct'

RSpec.describe 'EntitySchema inheritance from superclass' do
  let(:parent_klass) do
    Class.new do
      extend EntitySchema

      property   :foo
      object     :bar, map_to: OpenStruct
      collection :baz, map_to: OpenStruct
    end
  end

  let(:bad_parent_klass) do
    Class.new do
      def self.to_s
        'BadParent'
      end

      def self.entity_schema
        OpenStruct.new(dosent: :matter)
      end
    end
  end

  let(:clear_parent_klass) do
    Class.new
  end

  let(:children_klass) do
    Class.new(parent_klass) do
      has_one :quux, map_to: OpenStruct
    end
  end

  let(:bad_children_klass) do
    Class.new(bad_parent_klass) do
      extend EntitySchema

      has_one :quux, map_to: OpenStruct
    end
  end

  let(:clear_children_klass) do
    Class.new(clear_parent_klass) do
      extend EntitySchema

      has_one :quux, map_to: OpenStruct
    end
  end

  let(:entity) { children_klass.new(entity_params) }
  let(:entity_params) do
    {
      foo: 'FOO',
      bar: { x: 'BAR' },
      baz: [x: 'BAZ'],
      quux: { x: 'QUUX' }
    }
  end

  describe '[self-check]' do
    it { expect(parent_klass.new(entity_params).foo).to eq 'FOO' }
    it { expect(parent_klass.new(entity_params).bar.x).to eq 'BAR' }
    it { expect(parent_klass.new(entity_params).baz.first.x).to eq 'BAZ' }
  end

  describe 'children class has all fields' do
    it { expect(entity.foo).to eq 'FOO' }
    it { expect(entity.bar.x).to eq 'BAR' }
    it { expect(entity.baz.first.x).to eq 'BAZ' }
    it { expect(entity.quux.x).to eq 'QUUX' }
  end

  # rubocop:disable Layout/MultilineBlockLayout, Layout/BlockEndNewline
  context 'when inherited from parent with wrong `.schema`' do
    it { expect { bad_children_klass }.to raise_error 'class-level method `BadParent.entity_schema` is required by ' \
                                                      'gem "entity_schema" and must return instance of ' \
                                                      '`EntitySchema::Schema`, but returns a `OpenStruct`' }
  end
  # rubocop:enable Layout/MultilineBlockLayout, Layout/BlockEndNewline

  context 'when inherited from parent without EntitySchema' do
    let(:clear_entity) { clear_children_klass.new(entity_params) }

    it { expect { clear_children_klass }.not_to raise_error }
    it { expect(clear_entity.quux.x).to eq 'QUUX' }
  end
end
