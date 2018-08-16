# frozen_string_literal: true

RSpec.describe 'EntitySchema.property()' do
  let(:entity_klass) do
    Class.new do
      extend EntitySchema

      def self.to_s
        'Entity'
      end

      property  :property
      property  :property_name, key: :property_key
      property  :private_true,        private: true
      property  :setter_private,      setter:  :private
      property  :private_getter,      private: :getter
      property  :undefined
      property? :predicate
      property? :predicate_name, key: :predicate_key
    end
  end

  let(:entity) do
    entity_klass.new(
      property:            'property',
      property_name:       '-',
      property_key:        'property_key',
      private_true:        'private',
      private_setter_true: 'private_setter_true',
      setter_private:      'setter_private',
      private_getter:      'private_getter',
      predicate:           true,
      predicate_key:       false
    )
  end

  describe 'without options' do
    it { expect(entity.property).to                  eq 'property' }
    it { expect { entity.property   = 'changed' }.to change { entity[:property] }.from('property').to('changed') }
    it { expect(entity[:property]).to                eq 'property' }
    it { expect { entity[:property] = 'changed' }.to change { entity.property }.from('property').to('changed') }
    it { expect(entity.to_h[:property]).to           eq 'property' }
  end

  describe 'with `:key` option, access by name' do
    it { expect(entity.property_name).to                  eq 'property_key' }
    it { expect { entity.property_name   = 'changed' }.to change { entity[:property_name] }.from('property_key').to('changed') }
    it { expect(entity[:property_name]).to                eq 'property_key' }
    it { expect { entity[:property_name] = 'changed' }.to change { entity.property_name }.from('property_key').to('changed') }
    it { expect(entity.to_h.key?(:property_name)).to      be false }
  end

  describe 'with `:key` option, access by key' do
    it { expect { entity.property_key }.to               raise_error(NoMethodError) }
    it { expect { entity.property_key = 'changed' }.to   raise_error(NoMethodError) }
    it { expect { entity[:property_key] }.to             raise_error(NameError, "Unknown field 'property_key' for `Entity`") }
    it { expect { entity[:property_key] = 'changed' }.to raise_error(NameError, "Unknown field 'property_key' for `Entity`") }
    it { expect(entity.to_h[:property_key]).to           eq 'property_key' }
  end

  describe 'with `setter: :private` option' do
    it { expect(entity.setter_private).to                       eq 'setter_private' }
    it { expect { entity.setter_private   = 'changed' }.to      raise_error(NoMethodError) }
    it { expect(entity[:setter_private]).to                     eq 'setter_private' }
    it { expect { entity[:setter_private] = 'changed' }.to      raise_error(NameError, 'Private Setter called for field `setter_private` in `Entity`') }
    it { expect { entity.send(:setter_private=, 'changed') }.to change { entity.to_h[:setter_private] }.from('setter_private').to('changed') }
  end

  describe 'with `private: :getter` option' do
    it { expect { entity.private_getter }.to               raise_error(NoMethodError) }
    it { expect { entity.private_getter   = 'changed' }.to change { entity.to_h[:private_getter] }.from('private_getter').to('changed') }
    it { expect { entity[:private_getter] }.to             raise_error(NameError, 'Private Getter called for field `private_getter` in `Entity`') }
    it { expect { entity[:private_getter] = 'changed' }.to change { entity.to_h[:private_getter] }.from('private_getter').to('changed') }
    it { expect(entity.send(:private_getter)).to           eq 'private_getter' }
  end

  describe 'with `private: true` option' do
    it { expect { entity.private_true }.to                    raise_error(NoMethodError) }
    it { expect { entity.private_true = 'changed' }.to        raise_error(NoMethodError) }
    it { expect { entity[:private_true] }.to                  raise_error(NameError, 'Private Getter called for field `private_true` in `Entity`') }
    it { expect { entity[:private_true] = 'changed' }.to      raise_error(NameError, 'Private Setter called for field `private_true` in `Entity`') }
    it { expect(entity.send(:private_true)).to                eq 'private' }
    it { expect { entity.send(:private_true=, 'changed') }.to change { entity.to_h[:private_true] }.from('private').to('changed') }
    it { expect(entity.to_h[:private_true]).to                eq 'private' }
  end

  describe 'with .property? method, without options' do
    it { expect(entity.predicate).to              be true }
    it { expect(entity.predicate?).to             be true }
    it { expect { entity.predicate   = false }.to change { entity[:predicate] }.from(true).to(false) }
    it { expect(entity[:predicate]).to            be true }
    it { expect { entity[:predicate] = false }.to change { entity.predicate? }.from(true).to(false) }
    it { expect(entity.to_h[:predicate]).to       be true }
  end

  describe 'with .property? method, with `:key` option, access by name' do
    it { expect(entity.predicate_name?).to            be false }
    it { expect { entity.predicate_name   = true }.to change { entity[:predicate_name] }.from(false).to(true) }
    it { expect(entity[:predicate_name]).to           be false }
    it { expect { entity[:predicate_name] = true }.to change { entity.predicate_name }.from(false).to(true) }
    it { expect(entity.to_h.key?(:predicate_name)).to be false }
  end

  it '#to_h returns only permited keys' do
    params = {
      property:      'property',
      property_key:  'property_key',
      private_true:  'private',
      predicate:     true,
      predicate_key: false
    }
    expect(entity_klass.new(params).to_h).to eq params
  end
end
