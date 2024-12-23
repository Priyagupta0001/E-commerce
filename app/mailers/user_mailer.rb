class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url = 'http://example.com/login' # Login URL ya application ka link
    mail(to: @user.email, subject: 'Welcome to Our Ecommerce Website')
  end
end
