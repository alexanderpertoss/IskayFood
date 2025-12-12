class Cart < ApplicationRecord
  has_many :cart_products
  has_one :order

  def add_product(product_for_cart)
    CartProduct.create(quantity: 1, product_price: product_for_cart.price, product: product_for_cart, cart: self)
  end

  def cart_total
    total = 0
    cart_products.each do |cart_product|
      total += cart_product.product_price
    end
    total
  end
end
