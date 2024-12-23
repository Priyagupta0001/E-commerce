require 'rails_helper'

RSpec.describe CartItem, type: :model do

  context 'associations' do
    it 'belongs to a cart' do
      association = described_class.reflect_on_association(:cart)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a product' do
      association = described_class.reflect_on_association(:product)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  context 'validation tests' do
    it 'validates presence of product_id' do
      cart_item = CartItem.new(product_id: nil)
      expect(cart_item.errors[:product_id])
    end 

    it 'validates numericality of quantity (must be greater than or equal to 1)' do
      cart_item = CartItem.new(quantity: 0)
      expect(cart_item.errors[:quantity])
    end
    
    it 'validates stock availability' do
      product = Product.create( stock_quantity: 5)
      cart_item = CartItem.create(product: product, quantity: 6)
      expect(cart_item.errors[:stock_quantity]).to include('is out of stock')
    end
  end

end