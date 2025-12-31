class AddWeightToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :weight, :decimal, precision: 5, scale: 3, default: 0.0
  end
end
