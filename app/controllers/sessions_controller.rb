class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    #looking the user in the database
    @user = User.find_by(email: user_params[:email])
    
    if @user && @user.is_password?(user_params[:password])
      session[:user_id] = @user.id
      redirect_to posts_path
    else
      flash.now[:notice] = "Invalid email or password"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:role_id, :full_name, :email, :password, :phone_number, :status)
  end
end
