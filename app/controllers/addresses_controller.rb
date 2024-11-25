class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = @user.addresses
  end

  def new
    @address = @user.addresses.new
  end

  def create
    @address = @user.addresses.new(address_params)
    if @address.save
      redirect_to user_addresses_path
      flash[:notice]= 'Address added succesfully!'
    else
      render :new
    end
  end

  def edit
    @address
  end

  def update
    if @address.update(address_params)
      redirect_to user_addresses_path(@user)
      flash[:notice]= 'Address updated succesfully!'
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to user_addresses_path
    flash[:notice]= 'Address deleted succesfully!'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_address
    @address = @user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:street, :city, :state, :country, :zip_code)
  end
end
