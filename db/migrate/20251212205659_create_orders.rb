class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.decimal :total
      t.string :customer_name
      t.string :customer_shipping_address
      t.string :customer_phone
      t.string :customer_email
      t.string :status

      t.timestamps
    end
  end
end
