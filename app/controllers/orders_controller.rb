class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def index
    # byebug
    @orders = current_user.orders.includes(order_items: :product)
  end

  def show
    # Use find_by to find the order, if not found return an error message
    @order = current_user.orders.find_by(id: params[:id])

    if @order.nil?
      flash[:alert] = "Order not found."
      redirect_to orders_path
    end
  end

  private

  def set_cart
    @cart = current_user.cart
  end
end
