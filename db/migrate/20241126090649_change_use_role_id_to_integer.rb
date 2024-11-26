class ChangeUseRoleIdToInteger < ActiveRecord::Migration[8.0]
  def change
      change_column :users, :role_id, :integer, using: 'role_id::integer'
  end
end
