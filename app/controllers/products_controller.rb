class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin, only: [:edit, :update, :destroy] # Restrict editing, updating, and deleting to admins
  
  # GET /products
  def index
    @products = Product.all
  end
  
  # GET /products/:id
  def show
  end

  # GET /products/new
  def new
    if current_user&.role_id == 1
      @product = Product.new
    else
      redirect_to products_path, alert: "You are not authorized to create a product."
    end
  end

  # POST /products
  def create
    if current_user&.role_id == 1
      @product = Product.new(product_params)
      @product.image.attach(params[:product][:image])
      if @product.save
        flash[:notice] = 'Product was successfully created.'
        redirect_to @product
      else
        flash[:alert] = 'Failed to create product.'
        render :new
      end
    else
      redirect_to products_path, alert: "You are not authorized to create a product."
    end
  end

  # GET /products/:id/edit
  def edit
    @product
  end

  # PATCH/PUT /products/:id
  def update
    if @product.update(product_params)
      flash[:notice] = 'Product was successfully updated.'
      redirect_to @product
    else
      flash[:alert] = 'Failed to update product.'
      render :edit
    end
  end

  # DELETE /products/:id
  def destroy
    if @product.destroy
      flash[:notice] = 'Product was successfully destroyed.'
      redirect_to products_path
    else
      flash[:alert] = 'Failed to destroy product.'
      redirect_to products_path
    end
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    unless @product
      flash[:alert] = "Product not found"
      redirect_to products_path
    end
  end

  def authorize_admin
    unless current_user&.role_id == 1
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to products_path
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity, :main_image, gallery_images: [])
  end
end
