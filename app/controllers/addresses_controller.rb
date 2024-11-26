class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    if @user.present?
      @addresses = @user.addresses
    else
      @addresses = []
    end
  end

  def new
    @address = @user.addresses.new
  end

  def create
    @address = @user.addresses.new(address_params)
    if @address.save
      flash[:notice] = 'Address added successfully!'
      redirect_to user_addresses_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      flash[:notice] = 'Address updated successfully!'
      redirect_to user_addresses_path(@user)
    else
      render :edit
    end
  end

  def destroy
    if @address.destroy
      flash[:notice] = 'Address deleted successfully!'
    else
      flash[:alert] = 'Failed to delete address.'
    end
    redirect_to user_addresses_path(@user)
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
    if @user.nil?
      flash[:alert] = 'User not found.'
      redirect_to root_path # Fallback route
    end
  end

  def set_address
    if @user.present?
      @address = @user.addresses.find_by(id: params[:id])
      if @address.nil?
        flash[:alert] = 'Address not found.'
        redirect_to user_addresses_path(@user)
      end
    end
  end

  def address_params
    params.require(:address).permit(:street, :city, :state, :country, :zip_code)
  end
end
