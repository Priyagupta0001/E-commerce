class AddUserIdToCreditCards < ActiveRecord::Migration[8.0]
  def change
    add_reference :credit_cards, :user, null: false, foreign_key: true
  end
end
