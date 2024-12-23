require 'rails_helper'

RSpec.describe OrderItem, type: :model do

  context 'associations' do
    it 'belongs to a order' do
      association = described_class.reflect_on_association(:order)
      expect(association.macro).to eq(:belongs_to)
    end
    
    it 'belongs to a product' do
      association = described_class.reflect_on_association(:product)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  context 'validation tests' do
    it 'quantity must be greater than 0' do
      order_item = OrderItem.create(quantity: 0)
      expect(order_item.errors[:quantity]).to include('must be greater than 0')
    end
  end

  context 'callbacks' do
    it 'sets price before saving based on product price' do
      user = User.create!(email: 'priya@gmail.com', full_name: 'Priya', phone_number: '1234567890', password: 'password123', password_confirmation: 'password123')
      product = Product.create!(name: 'Laptop', price: 1000.0, stock_quantity: 50)
      order = Order.create!(user: user, total_price: 0.0, status: 'pending') # Assuming the `Order` model exists

      # Create OrderItem with quantity 2 and product
      order_item = OrderItem.new(order: order, product: product, quantity: 2)

      # Save order item and check that price is set correctly
      order_item.save
      expect(order_item.price).to eq(product.price)
      expect(order_item.price).to eq(1000.0)
    end
  end

end
