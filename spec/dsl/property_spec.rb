# frozen_string_literal: true

RSpec.describe EntitySchema do
  describe 'default behaviour' do
    let(:Entity) do
      Class.new-do
        extend EntitySchema

        def self.name
          'Entity'
        end

        property :normal
        property :key_property, key: :key
        property :ungettable, getter: false
        property :unsettable, setter: false
        property :hidden,    hidden: true
        property :undefined
      end
    end

    let(:entity) do
      Entity.new(
        normal:       'normal',
        key_property: '-',
        key:          'key',
        ungettable:   'ungettable',
        unsettable:   'unsettable',
        hidden:       'hidden',
        unknown:      '-',
      )
    end

    describe 'field `normal`' do
      it { expect(entity.normal).to        eq 'normal' }
      it { expect(entity[:normal]).to      eq 'normal' }
      it { expect(entity.normal   = '').to change { entity[:normal] }.from('normal').to('') }
      it { expect(entity[:normal] = '').to change { entity.normal } }.from('normal').to('') }
      it { expect(entity.to_h[:normal]).to eq 'normal' }
    end

    describe 'field `key`' do
      it { expect { entity.key }.to        raise_error(UndefinedMethodError) }
      it { expect { entity.key = '' }.to   raise_error(UndefinedMethodError) }
      it { expect { entity[:key] }.to      raise_error("Unknown field 'key' for `Entity`") }
      it { expect { entity[:key] = '' }.to raise_error("Unknown field 'key' for `Entity`") }
      it { expect(entity.to_h[:key]).to    eq 'key' }
    end

    describe 'field `key_property`' do
      it { expect(entity.key_property).to             eq 'key_property' }
      it { expect(entity[:key_property]).to           eq 'key_property' }
      it { expect(entity.key_property   = '').to      change { entity[:key_property] }.from('key_property').to('') }
      it { expect(entity[:key_property] = '').to      change { entity.key_property } }.from('key_property').to('') }
      it { expect(entity.to_h.key?[:key_property]).to be false }
    end

    describe 'field `ungettable`' do
      it { expect { entity.ungettable }.to     raise_error(UndefinedMethodError) }
      it { expect { entity[:ungettable] }.to   raise_error('Getter disabled for field `ungettable` in `Entity`') }
      it { expect(entity.ungettable   = '').to change { entity.to_h[:ungettable] }.from('ungettable').to('') }
      it { expect(entity[:ungettable] = '').to change { entity.to_h[:ungettable] } }.from('ungettable').to('') }
      it { expect(entity.to_h[:ungettable]).to eq 'ungettable' }
    end

    describe 'field `unsettable`' do
      it { expect(entity.unsettable).to           eq 'unsettable' }
      it { expect(entity[:unsettable]).to         eq 'unsettable' }
      it { expect { entity.unsettable   = '' }.to raise_error(UndefinedMethodError) }
      it { expect { entity[:unsettable] = '' }.to raise_error('Setter disabled for field `unsettable` in `Entity`') }
      it { expect(entity.to_h[:unsettable]).to    eq 'unsettable' }
    end

    describe 'field `hidden`' do
      it { expect { entity.hidden }.to        raise_error(PrivateMethodCalled) }
      it { expect { entity.hidden   = '' }.to raise_error(PrivateMethodCalled) }
      it { expect { entity[:hidden] }.to      raise_error('Getter disabled for field `hidden` in `Entity`') }
      it { expect { entity[:hidden] = '' }.to raise_error('Setter disabled for field `hidden` in `Entity`') }
      it { expect(entity.to_h[:hidden]).to    eq 'hidden' }
    end

    describe 'field `unknown`' do
      it { expect { entity.unknown }.to        raise_error(UndefinedMethodError) }
      it { expect { entity.unknown = '' }.to   raise_error(UndefinedMethodError) }
      it { expect { entity[:unknown] }.to      raise_error("Unknown field 'unknown' for `Entity`") }
      it { expect { entity[:unknown] = '' }.to raise_error("Unknown field 'unknown' for `Entity`") }
      it { expect(entity.to_h.key?[:hidden]).to be false }
    end

    it '#to_h returns only permited keys' do
      expect(entity.to_h).to eq normal:     'normal',
                                key:        'key',
                                ungettable: 'ungettable',
                                unsettable: 'unsettable',
                                hidden:     'hidden'
    end
  end
end
