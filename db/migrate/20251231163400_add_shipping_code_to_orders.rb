class AddShippingCodeToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :shipping_code, :string
  end
end
