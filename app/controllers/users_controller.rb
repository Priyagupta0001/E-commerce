class UsersController < ApplicationController

  def index
    @users = User.all  # All users fetch kar rahe hain
  end
  
  def new
    @user = User.new(role_id: 'customer') # Default role is customer
  end

  def show
    @user = User.find(params[:id])  # Find a specific user by ID
  end

  def create
    @user = User.new(user_params)
     # If you want to handle admin creation separately, you can add a condition here:
    @user.role_id ||= 'customer' # Ensure that the default is 'customer' if not set
    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:role_id, :full_name, :email, :password, :password_confirmation, :phone_number)
  end
end
