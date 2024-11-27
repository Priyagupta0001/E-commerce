class HomeController < ApplicationController
  def new
    @products = Product.all
  end
end
