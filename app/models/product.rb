class Product < ApplicationRecord
  has_one_attached :main_image
  has_many_attached :gallery_images
  has_many :cart
 
  # Validations
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  has_many :cart_items
  before_destroy :ensure_no_cart_items

  private

  def ensure_no_cart_items
    if cart_items.exists?
      errors.add(:base, "Cannot delete product while it is in a cart.")
      throw(:abort)
    end
  end
end

