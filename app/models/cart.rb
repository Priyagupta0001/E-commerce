class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  def total_price
    cart_items.includes(:product).sum { |item| item.quantity * item.product.price }
  end
end
