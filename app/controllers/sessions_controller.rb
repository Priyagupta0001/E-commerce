class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    #looking the user in the database
    @user = User.find_by(email: user_params[:email])
    
    if @user && @user.is_password?(user_params[:password])
      session[:user_id] = @user.id     #setsession to login user
      flash[:notice] = "Welcome to Home, #{@user.full_name}!"    # Flash welcome message
      redirect_to root_path     #redirect to home page
    else
      flash.now[:notice] = "Invalid email or password"
      redirect_to sign_in_path  #redirect back to signin page
    end
  end

  def destroy
    session[:user_id] = nil           # Clear session on sign out
    redirect_to root_path             # Redirect to home page
  end


  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
