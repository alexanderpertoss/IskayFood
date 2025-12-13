class Cart < ApplicationRecord
  has_many :cart_products
  has_one :order

  def add_product(product_for_cart)
    CartProduct.create!(
      quantity: 1,
      product_price: product_for_cart.price,
      product: product_for_cart,
      cart: self
      )
  end

  def cart_total
    cart_products.sum(:product_price)
  end

  def finalize_order
    Order.create!(
      total: cart_total,
      customer_name: "Alexander",
      customer_shipping_address: "ABCD",
      customer_phone: "1234567",
      customer_email: "aptpta@yahoo.es",
      status: "Recently created",
      cart: self
      ) unless cart_products.empty?
  end
end
