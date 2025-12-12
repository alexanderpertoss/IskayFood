class CreateCartProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_products do |t|
      t.integer :quantity
      t.decimal :product_price
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
