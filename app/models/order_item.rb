class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :quantity, numericality: { greater_than: 0 }

  # Ensure price matches the product price at the time of order
  before_save :set_price

  private

  def set_price
    self.price = product.price
  end
end
