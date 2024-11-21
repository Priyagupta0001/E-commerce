class User < ApplicationRecord
    validates :email , uniqueness: true
    validates :email , presence: true
    validates :phone_number, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }
    validates :password, length: { minimum: 5, allow_nil: true }

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
end
