class User < ApplicationRecord
    validates :email , uniqueness: true
    validates :email , presence: true
    validates :phone_number, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }
    
    has_secure_password
    validates :password, length: { minimum: 5, allow_nil: true }, confirmation: true

    has_many :addresses, dependent: :destroy

    has_one :cart, dependent: :destroy
    after_create :create_cart

    after_create :send_welcome_email

    has_many :orders

    has_many :credit_cards, dependent: :destroy

    before_create :assign_customer_id
    validates :role_id, presence: true

    def password
      @password
    end

    def password=(raw)
      @password = raw
      self.password_digest = BCrypt::Password.create(raw)
    end

    def is_password?(raw)
      BCrypt::Password.new(password_digest).is_password?(raw)
    end

    def create_cart
      Cart.create(user: self)
    end

    def send_welcome_email
      SendWelcomeEmailJob.perform_later(self)
    end

    def assign_customer_id
      customer = Stripe::Customer.create(email: email)
      # self.customer_id = customer.id
    end
end
