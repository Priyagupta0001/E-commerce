class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)

    @total_price = @cart_items.sum { |item| item.quantity * item.product.price }
  end

  def add
    product = Product.find_by(id: params[:product_id])
    if product
      # Find or initialize the cart item
      cart_item = @cart.cart_items.find_or_initialize_by(product_id: product.id)
      
      # Initialize quantity to 0 if it's nil, and then increment it
      cart_item.quantity ||= 0
      cart_item.quantity += 1
  
      if cart_item.save
        flash[:notice] = "#{product.name} added to your cart."
      else
        flash[:alert] = "Unable to add item to cart. #{cart_item.errors.full_messages.join(", ")}"
      end
    else
      flash[:alert] = "Product not found."
    end
    redirect_to products_path
  end
  
  def remove
    product_id = params[:product_id]
      cart_item = @cart.cart_items.find_by(product_id: product_id)
      if cart_item
        cart_item.destroy
        flash[:notice] = "Item removed from the cart."
      else
        flash[:alert] = "Item not found in your cart."
      end
    redirect_to cart_path
  end

  private
  def set_cart
    @cart = current_user.cart
  end
end
