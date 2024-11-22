class Address < ApplicationRecord
  belongs_to :user
  validates :street, :city, :state, :country, :zip_code, presence: true
end
