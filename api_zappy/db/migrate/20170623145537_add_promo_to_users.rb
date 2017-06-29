class AddPromoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :promo, :string
  end
end
