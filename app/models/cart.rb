class Cart < ApplicationRecord
  has_many :cart_products
  has_one :order

  def add_product(product_for_cart)
    current_item = cart_products.find_by(product_id: product_for_cart.id)
    was_newly_added = false

    if current_item
      current_item.quantity += 1
      current_item.save!
    else
      current_item = CartProduct.create!(
        quantity: 1,
        product_price: product_for_cart.price,
        product: product_for_cart,
        cart: self
      )
      was_newly_added = true
    end
    return current_item, was_newly_added
  end

  def remove_product(product_to_remove)
    current_item = cart_products.find_by(product_id: product_to_remove.id)
    return unless current_item

    if current_item.quantity > 1
      current_item.quantity -= 1
      current_item.save!
      current_item
    else
      current_item.destroy
      nil
    end
  end

  def cart_total
    cart_products.sum("quantity * product_price")
  end

  def total_items
    cart_products.sum(:quantity)
  end

  def quantity_of(product)
    item = cart_products.find_by(product: product)
    item.present? ? item.quantity : 0
  end

  def finalize_order(cust_name, cust_address, cust_phone, cust_email)
    Order.create!(
      total: cart_total,
      customer_name: cust_name,
      customer_shipping_address: cust_address,
      customer_phone: cust_phone,
      customer_email: cust_email,
      status: "Recently created",
      cart: self
      ) unless cart_products.empty?
  end
end
