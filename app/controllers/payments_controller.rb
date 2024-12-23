class PaymentsController < ApplicationController
  def checkout
    @cart = current_user.cart || Cart.create(user_id: current_user.id)
  
    # Ensure cart has items
    if @cart.cart_items.empty?
      flash[:alert] = "Your cart is empty."
      redirect_to cart_path
      return
    end
  
    # Calculate total price of cart items
    total_price = @cart.cart_items.sum { |cart_item| cart_item.product.price * cart_item.quantity }
  
    # Check for Stripe minimum threshold (50 cents)
    if total_price < 0.5
      flash[:alert] = "The total amount must be at least $0.50 USD to proceed."
      redirect_to cart_path
      return
    end
  
      # Ensure a cart exists
    @cart = current_user.cart

    # Initialize a new order
    order = Order.new(user: current_user)
    # Create a new order
    #order = current_user.orders.build(status: "pending")

    # Add items to the order
    @cart.cart_items.each do |cart_item|
      product = cart_item.product
      order.order_items.build(
        product: product,
        quantity: cart_item.quantity,
        price: product.price
      )
    end
  
    # Save the order
    order.total_price = total_price
    if order.save
      begin
      # Create Stripe Checkout session
      @session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: @cart.cart_items.map do |cart_item|
          {
            price_data: {
              currency: 'usd',
              product_data: {
                name: cart_item.product.name
              },
              unit_amount: (cart_item.product.price * 100).to_i  # Rounds properly in cents
            },
            quantity: cart_item.quantity
          }
        end,
        mode: 'payment',
        success_url: "#{success_payments_url(order_id: order.id)}&session_id={CHECKOUT_SESSION_ID}",
        cancel_url: cancel_payments_url
      })
    
      # Redirect to Stripe Checkout page
      redirect_to @session.url, allow_other_host: true
      rescue Stripe::CardError => e
        # Handle invalid card details like CVV or expiry
        flash[:alert] = "Payment failed: #{e.message}. Please check your card details."
        redirect_to cart_path
      rescue Stripe::InvalidRequestError => e
        # Handle other Stripe related errors
        flash[:alert] = "An error occurred. Please try again."
        redirect_to cart_path
      end
    else
      flash[:alert] = "Unable to place the order. Please try again."
      redirect_to cart_path
    end
  end
  
  def success
    order = Order.find_by(id: params[:order_id])
  
    if order && params[:session_id].present?
      begin
        # Retrieve Stripe session
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        payment_intent_id = session.payment_intent
  
        # Retrieve and verify payment intent
        payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
  
        if payment_intent.status == "succeeded"
          # Update order status and empty cart
          order.update(status: 'paid')
  
          # Clear user's cart items
          order.user.cart.cart_items.destroy_all 
  
          flash[:notice] = "Payment successful! Your order has been placed."
          redirect_to order_path(order)
        else
          flash[:alert] = "Payment not successful. Please try again."
          redirect_to cart_path
        end
      rescue Stripe::InvalidRequestError => e
        # Handle Stripe errors
        Rails.logger.error "Stripe Error: #{e.message}"
        flash[:alert] = "Invalid payment session. Please contact support."
        redirect_to root_path
      end
    else
      flash[:alert] = "Session ID is missing. Unable to verify payment."
      redirect_to root_path
    end
  end  
    
  def cancel
    flash[:alert] = "Payment was cancelled."
    redirect_to cart_path
  end
end
