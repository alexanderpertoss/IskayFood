class ShopController < ApplicationController
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
    @cart_product, @was_newly_added = @cart.add_product(@product)

    @cart.reload

    respond_to do |format|
      format.html { redirect_to products_path } # Fallback if Turbo is not active
      format.turbo_stream # Calls add_to_cart.turbo_stream.erb
    end
  end

  def remove_from_cart
    @product = Product.find(params[:id])
    @cart_product, @was_destroyed = @cart.remove_product(@product)

    @cart.reload

    respond_to do |format|
      format.html { redirect_to products_path } # Fallback
      format.turbo_stream # Llama a remove_product.turbo_stream.erb
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Producto no encontrado."
  end

  def confirm_order
    @order = @cart.finalize_order(params[:customer_name], params[:customer_shipping_address], params[:customer_phone], params[:customer_email])

    if @order.nil?
      redirect_to products_path
    else
      if @order.persisted?
        # Because the cart order was finalized, we reset the cart
        session[:cart_id] = nil
        redirect_to @order
      else
        redirect_to products_path
      end
    end
  end

  def update_delivery_fee
    # El fee viene como string, lo convertimos a float y lo guardamos en la sesión
    session[:delivery_fee] = params[:fee].to_f

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end
end
