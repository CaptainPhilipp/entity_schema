# frozen_string_literal: true

RSpec.describe EntitySchema do
  it 'has a version number' do
    expect(EntitySchema::VERSION).not_to be nil
  end
end
