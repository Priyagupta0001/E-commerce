class Product < ApplicationRecord
  has_one_attached :main_image
  has_many_attached :gallery_images
 
  has_many :cart
 
  has_many :cart_items
  before_destroy :ensure_no_cart_items

  has_many :orders, through: :order_items  # Adding the many-to-many relationship with orders via the join table
  has_many :order_items, dependent: :destroy  # This will delete associated order_items when the product is deleted

  # Validations
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }


  def reduce_stock(quantity)
    update(stock_quantity: stock_quantity - quantity)
  end

  def price_in_cents
    (price * 100).to_i
  end

  private

  def ensure_no_cart_items
    if cart_items.exists?
      errors.add(:base, "Cannot delete product while it is in a cart.")
      throw(:abort)
    end
  end
end

