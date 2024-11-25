class UsersController < ApplicationController

  def index
    @users = User.all  # All users fetch kar rahe hain
  end
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])  # Find a specific user by ID
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path
    else
     
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:role_id, :full_name, :email, :password, :phone_number)
  end
end
