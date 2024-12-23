class RemoveCustomerIdFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :customer_id, :string
  end
end
