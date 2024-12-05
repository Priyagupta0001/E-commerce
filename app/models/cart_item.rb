class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :product_id, presence: true

    
  validate :check_stock

  def check_stock
    if quantity > self.product.stock_quantity
      errors.add(:stock_quantity, "is out of stock")
    end
  end

end
