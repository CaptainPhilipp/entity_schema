# frozen_string_literal: true

RSpec.describe 'EntitySchema.property()' do
  let(:entity_klass) do
    Class.new do
      extend EntitySchema

      def self.to_s
        'Entity'
      end

      property  :property
      property  :property_name,  key: :property_key
      property  :ungettable,     getter: false
      property  :unsettable,     setter: false
      property  :private_setter, setter: :private
      property  :private_getter, private_getter: true
      property  :hidden,         hidden: true
      property  :privat,         private: true
      property  :undefined
      property? :predicate
      property? :predicate_name, key: :predicate_key
    end
  end

  let(:entity) do
    entity_klass.new(
      property:       'property',
      property_name:  '-',
      property_key:   'property_key',
      ungettable:     'ungettable',
      unsettable:     'unsettable',
      privat:         'private',
      private_getter: 'private_getter',
      private_setter: 'private_setter',
      hidden:         'hidden',
      predicate:      true,
      predicate_key:  false
    )
  end

  describe 'without options' do
    it { expect(entity.property).to               eq 'property' }
    it { expect(entity[:property]).to             eq 'property' }
    it { expect { entity.property   = 'changed' }.to change { entity[:property] }.from('property').to('changed') }
    it { expect { entity[:property] = 'changed' }.to change { entity.property }.from('property').to('changed') }
    it { expect(entity.to_h[:property]).to        eq 'property' }
  end

  describe 'with `:key` option, access by name' do
    it { expect(entity.property_name).to               eq 'property_key' }
    it { expect(entity[:property_name]).to             eq 'property_key' }
    it { expect { entity.property_name   = 'changed' }.to change { entity[:property_name] }.from('property_key').to('changed') }
    it { expect { entity[:property_name] = 'changed' }.to change { entity.property_name }.from('property_key').to('changed') }
    it { expect(entity.to_h.key?(:property_name)).to   be false }
  end

  describe 'with `:key` option, access by key' do
    it { expect { entity.property_key }.to               raise_error(NoMethodError) }
    it { expect { entity.property_key = 'changed' }.to   raise_error(NoMethodError) }
    it { expect { entity[:property_key] }.to             raise_error(NameError, "Unknown field 'property_key' for `Entity`") }
    it { expect { entity[:property_key] = 'changed' }.to raise_error(NameError, "Unknown field 'property_key' for `Entity`") }
    it { expect(entity.to_h[:property_key]).to           eq 'property_key' }
  end

  describe 'with `getter: false` option' do
    it { expect { entity.ungettable }.to               raise_error(NoMethodError) }
    it { expect { entity[:ungettable] }.to             raise_error(NameError, 'Getter disabled for field `ungettable` in `Entity`') }
    it { expect { entity.ungettable   = 'changed' }.to change { entity.to_h[:ungettable] }.from('ungettable').to('changed') }
    it { expect { entity[:ungettable] = 'changed' }.to change { entity.to_h[:ungettable] }.from('ungettable').to('changed') }
    it { expect(entity.to_h[:ungettable]).to           eq 'ungettable' }
  end

  describe 'with `setter: false` option' do
    it { expect(entity.unsettable).to                  eq 'unsettable' }
    it { expect(entity[:unsettable]).to                eq 'unsettable' }
    it { expect { entity.unsettable   = 'changed' }.to raise_error(NoMethodError) }
    it { expect { entity[:unsettable] = 'changed' }.to raise_error(NameError, 'Setter disabled for field `unsettable` in `Entity`') }
    it { expect(entity.to_h[:unsettable]).to          eq 'unsettable' }
  end

  describe 'with `getter: :private` option' do
    it { expect { entity.private_getter }.to     raise_error(NoMethodError) }
    it { expect { entity[:private_getter] }.to   raise_error(NameError, 'Private Getter called for field `private_getter` in `Entity`') }
    it { expect(entity.send(:private_getter)).to eq 'private_getter' }
  end

  describe 'with `setter: :private` option' do
    it { expect { entity.private_setter   = 'changed' }.to      raise_error(NoMethodError) }
    it { expect { entity[:private_setter] = 'changed' }.to      raise_error(NameError, 'Private Setter called for field `private_setter` in `Entity`') }
    it { expect { entity.send(:private_setter=, 'changed') }.to change { entity.to_h[:private_setter] }.from('private_setter').to('changed') }
  end

  describe 'with `private: true` option' do
    it { expect { entity.privat }.to                    raise_error(NoMethodError) }
    it { expect { entity.privat   = 'changed' }.to      raise_error(NoMethodError) }
    it { expect { entity[:privat] }.to                  raise_error(NameError, 'Private Getter called for field `privat` in `Entity`') }
    it { expect { entity[:privat] = 'changed' }.to      raise_error(NameError, 'Private Setter called for field `privat` in `Entity`') }
    it { expect(entity.send(:privat)).to                eq 'private' }
    it { expect { entity.send(:privat=, 'changed') }.to change { entity.to_h[:privat] }.from('private').to('changed') }
    it { expect(entity.to_h[:privat]).to               eq 'private' }
  end

  describe 'with `hidden: true` option' do
    it { expect { entity.hidden }.to               raise_error(NoMethodError) }
    it { expect { entity.hidden   = 'changed' }.to raise_error(NoMethodError) }
    it { expect { entity[:hidden] }.to             raise_error(NameError, 'Getter disabled for field `hidden` in `Entity`') }
    it { expect { entity[:hidden] = 'changed' }.to raise_error(NameError, 'Setter disabled for field `hidden` in `Entity`') }
    it { expect(entity.to_h[:hidden]).to            eq 'hidden' }
  end

  describe 'with .property? method, without options' do
    it { expect(entity.predicate).to           be true }
    it { expect(entity.predicate?).to          be true }
    it { expect(entity[:predicate]).to         be true }
    it { expect { entity.predicate   = false }.to change { entity[:predicate] }.from(true).to(false) }
    it { expect { entity[:predicate] = false }.to change { entity.predicate? }.from(true).to(false) }
    it { expect(entity.to_h[:predicate]).to    be true }
  end

  describe 'with .property? method, with `:key` option, access by name' do
    it { expect(entity.predicate_name?).to            be false }
    it { expect(entity[:predicate_name]).to           be false }
    it { expect { entity.predicate_name   = true }.to change { entity[:predicate_name] }.from(false).to(true) }
    it { expect { entity[:predicate_name] = true }.to change { entity.predicate_name }.from(false).to(true) }
    it { expect(entity.to_h.key?(:predicate_name)).to be false }
  end

  it '#to_h returns only permited keys' do
    params = {
      property:      'property',
      property_key:  'property_key',
      ungettable:    'ungettable',
      unsettable:    'unsettable',
      privat:        'private',
      hidden:        'hidden',
      predicate:     true,
      predicate_key: false,
    }
    expect(entity_klass.new(params).to_h).to eq params
  end
end
