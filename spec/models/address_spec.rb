require 'rails_helper'

RSpec.describe Address, type: :model do
  
  context 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  context 'validation tests' do
    it 'presence of all fields' do
      address = Address.create
      expect(address.errors[:street]).to include("can't be blank")
      expect(address.errors[:city]).to include("can't be blank")
      expect(address.errors[:state]).to include("can't be blank")
      expect(address.errors[:country]).to include("can't be blank")
      expect(address.errors[:zip_code]).to include("can't be blank")
    end
  end

end