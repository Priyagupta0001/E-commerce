class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  after_action :initialize_cart, if: :user_signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    redirect_to sign_in_path, alert: "Please log in first" unless current_user
  end

  private
  # Ye function user ke login hone par cart ko session mein initialize karega
  def initialize_cart
    session[:cart] ||= {} # Agar session mein cart nahi hai, to naya cart bana do
  end

  # user_signed_in? method check karega ki user logged in hai ya nahi
  def user_signed_in?
    current_user.present?
  end
end
