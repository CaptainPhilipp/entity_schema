# frozen_string_literal: true

RSpec.describe 'EntitySchema.property()' do
  let(:Entity) do
    Class.new-do
      extend EntitySchema

      def self.name
        'Entity'
      end

      property  :property
      property  :property_name, key: :property_key
      property  :ungettable, getter: false
      property  :unsettable, setter: false
      property  :hidden,     hidden: true
      property  :private,    private: true
      property  :undefined
      property? :predicate
      property? :predicate_name, key: :predicate_key
    end
  end

  let(:entity) do
    Entity.new(
      property:      'property',
      property_name: '-',
      property_key:  'property_key',
      ungettable:    'ungettable',
      unsettable:    'unsettable',
      private:       'private',
      hidden:        'hidden',
      predicate:     true,
      predicate_key: false
    )
  end

  describe 'without options' do
    skip 'TODO'
    it { expect(entity.property).to        eq 'property' }
    it { expect(entity[:property]).to      eq 'property' }
    it { expect(entity.property   = '').to change { entity[:property] }.from('property').to('') }
    it { expect(entity[:property] = '').to change { entity.property } }.from('property').to('') }
    xit { expect(entity.to_h[:property]).to eq 'property' }
  end

  describe 'with `:key` option, access by name' do
    skip 'TODO'
    it { expect(entity.property_name).to             eq 'property_key' }
    it { expect(entity[:property_name]).to           eq 'property_key' }
    it { expect(entity.property_name   = '').to      change { entity[:property_name] }.from('property_key').to('') }
    it { expect(entity[:property_name] = '').to      change { entity.property_name } }.from('property_key').to('') }
    xit { expect(entity.to_h.key?[:property_name]).to be false }
  end

  describe 'with `:key` option, access by key' do
    skip 'TODO'
    it { expect { entity.property_key }.to        raise_error(NoMethodError) }
    it { expect { entity.property_key = '' }.to   raise_error(NoMethodError) }
    it { expect { entity[:property_key] }.to      raise_error(NameError, "Unknown field 'property_key' for `Entity`") }
    it { expect { entity[:property_key] = '' }.to raise_error(NameError, "Unknown field 'property_key' for `Entity`") }
    xit { expect(entity.to_h[:property_key]).to    eq 'property_key' }
  end

  describe 'with `getter: false` option' do
    skip 'TODO'
    it { expect { entity.ungettable }.to     raise_error(NoMethodError) }
    it { expect { entity[:ungettable] }.to   raise_error(NameError, 'Getter hidden for field `ungettable` in `Entity`') }
    it { expect(entity.ungettable   = '').to change { entity.to_h[:ungettable] }.from('ungettable').to('') }
    it { expect(entity[:ungettable] = '').to change { entity.to_h[:ungettable] } }.from('ungettable').to('') }
    xit { expect(entity.to_h[:ungettable]).to eq 'ungettable' }
  end

  describe 'with `setter: false` option' do
    skip 'TODO'
    it { expect(entity.unsettable).to           eq 'unsettable' }
    it { expect(entity[:unsettable]).to         eq 'unsettable' }
    it { expect { entity.unsettable   = '' }.to raise_error(NoMethodError) }
    it { expect { entity[:unsettable] = '' }.to raise_error(NameError, 'Setter hidden for field `unsettable` in `Entity`') }
    xit { expect(entity.to_h[:unsettable]).to    eq 'unsettable' }
  end

  describe 'with `private: true` option' do
    skip 'TODO'
    it { expect { entity.private }.to               raise_error(NoMethodError) }
    it { expect { entity.private   = '' }.to        raise_error(NoMethodError) }
    it { expect { entity[:private] }.to             raise_error(NameError, 'Private Getter called for field `private` in `Entity`') }
    it { expect { entity[:private] = '' }.to        raise_error(NameError, 'Private Setter called for field `private` in `Entity`') }
    it { expect { entity.send(:private) }.to        eq 'private' }
    it { expect { entity.send(:private)   = '' }.to eq 'private' }
    xit { expect(entity.to_h[:private]).to           eq 'private' }
  end

  describe 'with `hidden: true` option' do
    skip 'TODO'
    it { expect { entity.hidden }.to        raise_error(NoMethodError) }
    it { expect { entity.hidden   = '' }.to raise_error(NoMethodError) }
    it { expect { entity[:hidden] }.to      raise_error(NameError, 'Getter hidden for field `hidden` in `Entity`') }
    it { expect { entity[:hidden] = '' }.to raise_error(NameError, 'Setter hidden for field `hidden` in `Entity`') }
    xit { expect(entity.to_h[:hidden]).to    eq 'private' }
  end

  describe 'with .property? method, without options' do
    skip 'TODO'
    it { expect(entity.predicate?).to          be true }
    it { expect(entity[:predicate]).to         be true }
    it { expect(entity.predicate   = false).to change { entity[:predicate] }.from(true).to(false) }
    it { expect(entity[:predicate] = false).to change { entity.predicate? } }.from(true).to(false) }
    xit { expect(entity.to_h[:predicate]).to    be true }
  end

  describe 'with .property? method, with `:key` option, access by name' do
    skip 'TODO'
    it { expect(entity.predicate_name?).to            be false }
    it { expect(entity[:predicate_name]).to           be false }
    it { expect(entity.predicate_name   = true).to    change { entity[:predicate_name] }.from(false).to(true) }
    it { expect(entity[:predicate_name] = true).to    change { entity.predicate_name } }.from(false).to(true) }
    xit { expect(entity.to_h.key?[:predicate_name]).to be false }
  end

  describe 'with .property? method, with `:key` option, access by key' do
    skip 'TODO'
    it { expect { entity.predicate_key? }.to       raise_error(NoMethodError) }
    it { expect { entity.predicate_key = '' }.to   raise_error(NoMethodError) }
    it { expect { entity[:predicate_key] }.to      raise_error(NameError, "Unknown field `predicate_key` for `Entity`") }
    it { expect { entity[:predicate_key] = '' }.to raise_error(NameError, "Unknown field `predicate_key` for `Entity`") }
    xit { expect(entity.to_h[:predicate_key]).to    eq 'predicate_key' }
  end

  it '#to_h returns only permited keys' do
    expect(entity.to_h).to eq property:        'property',
                              property_key:   'property_key',
                              ungettable:    'ungettable',
                              unsettable:    'unsettable',
                              private:       'private',
                              hidden:        'hidden',
                              predicate:     true,
                              predicate_key: false
  end

  it 'Not affects Hash' do
    params = {
      property:        'property',
      property_key:   'property_key',
      ungettable:    'ungettable',
      unsettable:    'unsettable',
      private:       'private',
      hidden:        'hidden',
      predicate:     true,
      predicate_key: false,
    }
    expect(Entity.new(params).to_h).to eq params
  end
end
