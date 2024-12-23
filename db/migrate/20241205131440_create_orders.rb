class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0.0
      t.string :status, default: "pending" # pending, completed, cancelled

      t.timestamps
    end
  end
end
