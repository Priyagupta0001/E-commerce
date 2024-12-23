require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  # Create a user, cart, and product manually in each test
  let(:user) { User.create!(email: 'priya@gmail.com', password: 'password123', phone_number: '1234567890') }
  let(:cart) { Cart.create!(user: user) }
  let(:product) { Product.create!(name: 'Mobiles', price: 100.0, stock_quantity: 10) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'when the cart is empty' do
      before do
        cart.cart_items.destroy_all # Empty the cart
      end

      it 'redirects to the cart path with an alert' do
        post :create
        expect(response).to redirect_to(cart_path)
      end
    end

    context 'when the cart has items but insufficient stock' do
      before do
        cart.cart_items.create(product: product, quantity: 15) # Insufficient stock (only 10 available)
      end

      it 'redirects to the cart path with an alert' do
        post :create
        expect(response).to redirect_to(cart_path)
      end
    end

    context 'when the cart has sufficient items and stock' do
      before do
        cart.cart_items.create!(product: product, quantity: 5) # Sufficient stock
      end

      it 'creates a new order and redirects to the order path' do
        post :create
        expect(response).to redirect_to(order_path(Order.last))
      end
    end
  end

  describe 'GET #show' do
    let(:order) { Order.create!(user: user, status: 'pending') }

    context 'when the order exists' do
      it 'returns a successful response' do
        get :show, params: { id: order.id }
        expect(response).to be_successful
      end
    end

    context 'when the order does not exist' do
      it 'redirects to orders path with an alert' do
        get :show, params: { id: -1 }
        expect(response).to redirect_to(orders_path)
      end
    end
  end
end
