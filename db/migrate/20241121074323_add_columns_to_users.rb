class AddColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role_id, :string
    add_column :users, :full_name, :string
    add_column :users, :phone_number, :string
  end
end
