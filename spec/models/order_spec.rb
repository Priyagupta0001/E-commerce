require 'rails_helper'

RSpec.describe Order, type: :model do

  context 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has one address' do
      association = described_class.reflect_on_association(:address)
      expect(association.macro).to eq(:has_one)
    end

    it 'has many order_items' do
      association = described_class.reflect_on_association(:order_items)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many products through order_items' do
      association = described_class.reflect_on_association(:products)
      expect(association.macro).to eq(:has_many)
    end
  end

  context 'validation tests' do
    it 'numericality of total_price (greater than or equal to 0)' do
      order = Order.create({total_price: -5.0})
      expect(order.errors[:total_price]).to include('must be greater than or equal to 0')
    end
  end

  context 'callbacks' do
    it 'sets order_number before creating the order' do
      user = User.create!(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890', password: 'password123', password_confirmation: 'password123')
      order1 = Order.create!(user: user, total_price: 100.0)
      order2 = Order.create!(user: user, total_price: 200.0)
      
      # The order number for the second order should be 2
      expect(order2.order_number).to eq(2)
    end
  end

  context 'methods' do
    it 'calculates the total price correctly' do
      user = User.create!(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890', password: 'password123', password_confirmation: 'password123')
      product1 = Product.create!(name: 'Product 1', price: 50.0)
      product2 = Product.create!(name: 'Product 2', price: 100.0)
      order = Order.create!(user: user, total_price: 0.0)
      
      # Add items to the order
      OrderItem.create!(order: order, product: product1, quantity: 2)
      OrderItem.create!(order: order, product: product2, quantity: 1)

      # Calculate total
      order.calculate_total
      
      # The total price should be (2 * 50) + (1 * 100) = 200
      expect(order.total_price).to eq(200.0)
    end
  end
end