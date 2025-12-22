class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.string :name
      t.string :email
      t.date :date
      t.time :time
      t.integer :people

      t.timestamps
    end
  end
end
