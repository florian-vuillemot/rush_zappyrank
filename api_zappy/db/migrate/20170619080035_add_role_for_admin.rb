class AddRoleForAdmin < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :integer
    change_column :users, :ranking, :integer
  end
end
