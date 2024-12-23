require 'rails_helper'

RSpec.describe Product, type: :model do
  
  #Test association
  context 'associations' do
    it 'has one attached main_image' do
      product = Product.new
      expect(product.main_image).to be_an_instance_of(ActiveStorage::Attached::One)
    end

    it 'has many attached gallery_images' do
      product = Product.new
      expect(product.gallery_images).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    it 'has many cart' do
      association = described_class.reflect_on_association(:cart)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many cart_items' do
      association = described_class.reflect_on_association(:cart_items)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many orders through order_items' do
      association = described_class.reflect_on_association(:orders)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many order_items' do
      association = described_class.reflect_on_association(:order_items)
      expect(association.macro).to eq(:has_many)
    end
  end
 
  #Test validations
  context 'validation tests' do
    it 'name presence' do
      product = Product.create(price: 10.0)
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'numericality of price (must be greater than or equal to 0)' do
      product = Product.create(name: 'Mobiles', price: -5.0)
      expect(product.errors[:price]).to include('must be greater than or equal to 0')
    end
  end

  #Test method
  context 'methods' do
    it 'reduces stock correctly' do
      product = Product.create(name: 'Test Product', price: 100, stock_quantity: 10)
      product.reduce_stock(3)
      expect(product.stock_quantity).to eq(7)
    end
  end
  
  # Test Callbacks
  context 'callbacks' do
    it 'does not allow deletion of product if it is in a cart' do
      # Assuming Cart and CartItem models exist
      user = User.create!(email: 'testuser@example.com', full_name: 'Test User', phone_number: '1234567890', password: 'password123', password_confirmation: 'password123')
      product = Product.create!(name: 'Test Product', price: 100, stock_quantity: 10)
      cart = Cart.create!(user: user)
      CartItem.create!(cart: cart, product: product, quantity: 1)
      
      expect { product.destroy }.to_not change { Product.count }
      expect(product.errors[:base]).to include("Cannot delete product while it is in a cart.")
    end
  end

end
