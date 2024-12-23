class Address < ApplicationRecord
  belongs_to :user
  validates :street, :city, :state, :country, :zip_code, presence: true

  def full_address
    "#{street}, #{city}, #{state}, #{country} - #{zip_code}"
  end
end
