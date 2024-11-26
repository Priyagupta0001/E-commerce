class Product < ApplicationRecord
    has_one_attached :main_image
    has_many_attached :gallery_images
  
    # Validations
    validates :name, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }
end
