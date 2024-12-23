class Order < ApplicationRecord
  belongs_to :user
  has_one :address
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
   
  before_create :set_order_number
  
  # Method to calculate total price from order items
  def calculate_total
    self.total_price = order_items.sum { |item| item.quantity * item.price }
    save
  end

  private

  def set_order_number
    # Current user ke orders ka count + 1
    self.order_number = user.orders.count + 1
  end
end
