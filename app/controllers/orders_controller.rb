class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy order_status_check ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all.order(created_at: :desc)
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    @order.status = "Shipped"
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_path, notice: "Order was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, notice: "Order was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def prepare_order
    @order = Order.find(params[:id])
    @order.status = "Preparing order"
    @order.save!
    redirect_to orders_path
  end

  def shipped
    @order = Order.find(params[:id])
    @order.status = "Shipped"
    @order.save!
    redirect_to orders_path
  end

  def delivered
    @order = Order.find(params[:id])
    @order.status = "Delivered"
    @order.save!
    redirect_to orders_path
  end

  def cancelled
    @order = Order.find(params[:id])
    @order.status = "Cancelled"
    @order.save!
    redirect_to orders_path
  end

  def success
    # Ahora sí, el pedido es firme: vaciamos el carrito
    session[:cart_id] = nil
    @cart = nil
    @order = Order.find(params[:order_id])
    redirect_to @order
  end

  def cancel
    redirect_to root_path
  end

  def order_status_check
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.expect(order: [ :total, :customer_name, :customer_shipping_address, :customer_phone, :customer_email, :status, :shipping_code ])
    end
end
