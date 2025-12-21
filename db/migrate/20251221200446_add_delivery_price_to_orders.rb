class AddDeliveryPriceToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :delivery_price, :decimal
  end
end
