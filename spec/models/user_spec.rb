require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation tests' do
    it 'validates presence of email' do
      user = User.create(full_name: 'Priya', phone_number: '1234567890', password: 'password123', password_confirmation: 'password123')
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'validates uniqueness of email' do
      User.create!(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890', password: 'password123', password_confirmation: 'password123')
      user2 = User.create(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '0987654321', password: 'password123', password_confirmation: 'password123')
      expect(user2.errors[:email]).to include('has already been taken')
    end

    it 'validates presence of phone number' do
      user = User.create(email: 'priya@gmail.com', full_name: 'Priya', password: 'password123', password_confirmation: 'password123')
      expect(user.errors[:phone_number].join(", ")).to include("can't be blank")
    end

    it 'validates format of phone number (10 digits)' do
      user = User.create(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '123456789', password: 'password123', password_confirmation: 'password123')
      expect(user.errors[:phone_number].join(", ")).to include('must be 10 digits')
    end

    it 'validates minimum password length of 5 characters' do
      user = User.create(password: '1234', password_confirmation: '1234', email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890')
      expect(user.errors[:password]).to include('is too short (minimum is 5 characters)')
    end

    it 'allows password to be nil' do
      user = User.create(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890')
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'validates password confirmation matches password' do
      user = User.create(password: 'password123', password_confirmation: 'differentpassword', email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890')
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context 'association tests' do
    it 'has many addresses' do
      association = described_class.reflect_on_association(:addresses)
      expect(association.macro).to eq(:has_many)
    end

    it 'has one cart' do
      association = described_class.reflect_on_association(:cart)
      expect(association.macro).to eq(:has_one)
    end

    it 'has many orders' do
      association = described_class.reflect_on_association(:orders)
      expect(association.macro).to eq(:has_many)
    end
  end

  context 'callback tests' do
    it 'creates a cart after user creation' do
      user = User.create!(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890', password: 'password123', password_confirmation: 'password123')
      expect(user.cart).not_to be_nil
    end

    it 'sends a welcome email after user creation' do
      expect(SendWelcomeEmailJob).to receive(:perform_later)
      User.create!(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890', password: 'password123', password_confirmation: 'password123')
    end
  end
end
