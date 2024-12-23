class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)
    @total_price = @cart_items.sum { |item| item.quantity * item.product.price }
    @addresses = current_user.addresses
    if params[:selected_address].present?
      session[:selected_address] = params[:selected_address]
    end
    @selected_address = session[:selected_address]
  end

  def add
    product = Product.find_by(id: params[:product_id])

    if product
      # Check if product is out of stock
      if product.stock_quantity <= 0
        flash[:alert] = "#{product.name} is out of stock!"
      else
        # Find or initialize the cart item
        cart_item = @cart.cart_items.find_or_initialize_by(product_id: product.id)
        cart_item.quantity ||= 0

        # Check if adding exceeds stock
        if cart_item.quantity < product.stock_quantity
          cart_item.quantity += 1
          if cart_item.save
            flash[:notice] = "#{product.name} added to your cart."
          else
            flash[:alert] = "Unable to add item to cart. #{cart_item.errors.full_messages.join(", ")}"
          end
        else
          flash[:alert] = "Only #{product.stock_quantity} units of #{product.name} are available."
        end
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
