class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create ]

  def create
    # Calculamos el total (Subtotal + Delivery Fee guardado en session)
    # Stripe recibe los montos en CENTAVOS (e.g., 10.50 EUR -> 1050)
    amount_in_cents = ((@cart.cart_total + session[:delivery_fee].to_f) * 100).to_i

    session = Stripe::Checkout::Session.create({
      payment_method_types: [ "bancontact", "card" ], # Habilitamos Bancontact
      line_items: [ {
        price_data: {
          currency: "eur",
          product_data: { name: "IskayFood Order" },
          unit_amount: amount_in_cents
        },
        quantity: 1
      } ],
      mode: "payment",
      success_url: order_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cart_url
    })

    # Redirigimos directamente a la pasarela alojada de Stripe
    redirect_to session.url, allow_other_host: true
  end
end
