# frozen_string_literal: true

require 'ostruct'

RSpec.describe 'EntitySchema.object()' do
  let(:entity_klass) do
    Class.new do
      extend EntitySchema

      def self.to_s
        'Entity'
      end

      object :normal, map_to: OpenStruct
      object :object_accessor, map_to: OpenStruct, key: :object_key
      object :object_accessor, map_to: OpenStruct, getter: :private
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

  def ostruct(*opts)
    OpenStruct.new(*opts)
  end
end
