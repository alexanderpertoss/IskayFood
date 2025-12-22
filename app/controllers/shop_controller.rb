require "net/http"
require "json"

class ShopController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :confirm_order ]
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
    @order = @cart.finalize_order(
      params[:customer_name],
      params[:order][:shipping_address],
      params[:customer_phone],
      params[:customer_email],
      params[:delivery_price]
    )

    if @order&.persisted?
      # Configuramos Stripe
      Stripe.api_key = "sk_test_51SgtKUINuHdo5ddVr8jz3OGxzPumj9sDQyeBK9qejvW4Xlwx2KSSc3bsh8stMiezl5Czpzs7WRxx4g60BY4bcTHU00gEMmAomD"

      session = Stripe::Checkout::Session.create({
        payment_method_types: [ "bancontact", "card", "klarna" ],
        line_items: [ {
          price_data: {
            currency: "eur",
            product_data: { name: "IskayFood Order ##{@order.id}" },
            # El cálculo de centavos está perfecto
            unit_amount: (((@order.total + @order.delivery_price).to_f) * 100).round.to_i
          },
          quantity: 1
        } ],
        mode: "payment",
        # Pasamos el ID de nuestra orden local para identificarla al volver
        success_url: order_success_url + "?session_id={CHECKOUT_SESSION_ID}&order_id=#{@order.id}",
        cancel_url: cancel_cart_url
      })

      # Redirigimos a Stripe y detenemos la ejecución con "return"
      redirect_to session.url, allow_other_host: true and return
    else
      # Si la orden no se guardó bien, volvemos a la tienda
      redirect_to products_path, alert: "Error creating order." and return
    end
  end

  def update_delivery_fee
    postal_code = params[:postal_code]
    country_code = params[:country_code]

    # 1. Limpia cualquier espacio en blanco accidental
    username = "86fc0a40-8974-4e4f-bd91-fa87f735835d"
    password = "3fd0b0acd11944809ac0caab0a0539ed"

    uri = URI("https://panel.sendcloud.sc/api/v3/shipping-options")
    request = Net::HTTP::Post.new(uri)

    # 2. Construir el Header de Autorización manualmente según la documentación
    auth_string = Base64.strict_encode64("#{username}:#{password}")
    request["Authorization"] = "Basic #{auth_string}"

    # 3. Headers obligatorios adicionales
    request["Content-Type"] = "application/json"
    request["Accept"] = "application/json"

    # 4. Cuerpo de la petición
    request.body = {
      from_country_code: "BE",
      to_country_code: country_code,
      to_postal_code: postal_code,
      weight: {
        value: "1",
        unit: "kg"
      },
      calculate_quotes: true
    }.to_json



    # 5. Ejecución
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    puts "TEST--------------------------------------------------"
    puts response.code

    if response.code == "200"
      data = JSON.parse(response.body)["data"]

      puts "CANTIDAD DE OPCIONES: #{data.length}"
      data.each do |opt|
        puts "Carrier: #{opt['carrier']['name']} | Método: #{opt['name']} | Precio: #{opt['quotes']&.first&.dig('price', 'total', 'value')}"
      end

      # 1. Mapeamos los métodos disponibles
      available_methods = data.map do |option|
        quote = option["quotes"]&.first
        next if quote.nil?

        # Extraemos el precio total
        total_price = quote.dig("price", "total", "value").to_f

        # Ignoramos métodos con precio 0 (como Unstamped letter) o sin carrier real
        next if total_price <= 0 || option["carrier"]["code"] == "sendcloud"

        {
          name: option["name"],
          carrier: option["carrier"]["code"],
          price: total_price,
          currency: quote.dig("price", "total", "currency"),
          lead_time: quote["lead_time"] # Por si quieres mostrar "Entrega en 24h"
        }
      end.compact

      # 2. Selección de la mejor opción
      # Priorizamos bpost si existe (muy común en BE), si no, el más barato de DPD
      best_option = available_methods.min_by { |m| m[:price] }

      if best_option
        @fee = best_option[:price]
        @method_name = best_option[:name]
        puts "SUCCES: Seleccionado #{@method_name} con costo #{@fee}"
      else
        @fee = 7.50
        @method_name = "Standard Shipping"
        puts "WARN: No se encontraron métodos válidos, usando fallback."
      end
    else
      puts "DEBUG: Error de Sendcloud #{response.code} - #{response.body}"
      @fee = 7.50
      @method_name = "Delivery Service"
    end

    respond_to do |format|
      format.turbo_stream
    end
  end
end
