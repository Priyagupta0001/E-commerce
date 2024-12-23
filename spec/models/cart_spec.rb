require 'rails_helper'

RSpec.describe Cart, type: :model do
  # Setup user and cart before each test
  before do
    @user = User.create!(email: 'priya@gmail.com', password: 'password123', phone_number: '1234567890')
    @cart = Cart.create!(user: @user)
  end

  context 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
    
    it 'has many cart_items' do
      association = described_class.reflect_on_association(:cart_items)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroys cart_items when cart is destroyed' do
      product = Product.create!(name: 'Product 1', price: 10.0, stock_quantity: 100)
      cart_item = CartItem.create!(cart: @cart, product: product, quantity: 2)
      
      expect { @cart.destroy }.to change { CartItem.count }.by(-1)
    end
  end

  it 'calculates the total price of all cart items correctly' do
    product1 = Product.create!(name: 'Laptop', price: 1000.0, stock_quantity: 50)
    product2 = Product.create!(name: 'Mouse', price: 50.0, stock_quantity: 100)

    @cart.cart_items.create!(product: product1, quantity: 2)
    @cart.cart_items.create!(product: product2, quantity: 3)

    expect(@cart.total_price).to eq(2150.0)
  end

  it 'returns 0 if there are no cart items' do
    expect(@cart.total_price).to eq(0)
  end
end
