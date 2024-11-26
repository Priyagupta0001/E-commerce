class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :edit, :update, :destroy]
    
    # GET /products
    def index
      @products = Product.all
    end
    
    # GET /products/:id
    def show
    end
    
    # GET /products/new
    def new
      @product = Product.new
    end
    
    # POST /products
    def create
      @product = Product.new(product_params)
    
      if @product.save
        redirect_to @product 
        flash[:notice] = 'Product was successfully created.'
      else
        flash[:alert] = 'Failed to create product.'
        render :new
      end
    end
    
    # GET /products/:id/edit
    def edit
    end
    
    # PATCH/PUT /products/:id
    def update
      if @product.update(product_params)
        redirect_to @product
        flash[:notice] = 'Product was successfully updated.'
      else
        flash[:alert] = 'Failed to update product.'
        render :edit
      end
    end
    
    # DELETE /products/:id
    def destroy
      if @product.destroy
        redirect_to products_url
        flash[:notice] = 'Product was successfully destroyed.'
      else
        flash[:alert] = 'Failed to destroy product.'
        redirect_to products_url  
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
    
    
    def product_params
      params.require(:product).permit(:name, :description, :price, :stock_quantity, :main_image, gallery_images: [])
    end
    
  end
  