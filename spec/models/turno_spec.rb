require 'rails_helper'

RSpec.describe Turno, type: :model do
  it 'is valid with valid attributes' do
    turno = Turno.new(attribute1: 'value1', attribute2: 'value2')
    expect(turno).to be_valid
  end

  it 'is not valid without attribute1' do
    turno = Turno.new(attribute2: 'value2')
    expect(turno).to_not be_valid
  end

  it 'has many associations' do
    assoc = Turno.reflect_on_association(:association_name)
    expect(assoc.macro).to eq(:has_many)
  end

  it 'validates presence of attribute1' do
    turno = Turno.new(attribute1: nil)
    expect(turno).to_not be_valid
  end
end