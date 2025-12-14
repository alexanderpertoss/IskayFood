class ShopController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @ninth_product = Product.order(created_at: :asc).offset(8).first
    @eigth_product = Product.order(created_at: :asc).offset(7).first
    @seventh_product = Product.order(created_at: :asc).offset(6).first
    @sixth_product = Product.order(created_at: :asc).offset(5).first
    @fifth_product = Product.order(created_at: :asc).offset(4).first
    @fourth_product = Product.order(created_at: :asc).offset(3).first
    @third_product = Product.order(created_at: :asc).offset(2).first
    @second_product = Product.order(created_at: :asc).offset(1).first
    @first_product = Product.order(created_at: :asc).first
  end

  def shopping_cart
  end

  def add_to_cart
    @product = Product.find(params[:id])
    @cart.add_product(@product)
    redirect_to products_path
  end

  def confirm_order
    @order = @cart.finalize_order

    if @order.nil?
      redirect_to products_path
    else
      if @order.persisted?
        # Because the cart order was finalized, we reset the cart
        session[:cart_id] = nil
      else
        redirect_to products_path
      end
    end
  end
end
