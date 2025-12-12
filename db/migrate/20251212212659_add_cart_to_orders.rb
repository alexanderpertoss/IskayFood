class AddCartToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :cart, null: false, foreign_key: true
  end
end
