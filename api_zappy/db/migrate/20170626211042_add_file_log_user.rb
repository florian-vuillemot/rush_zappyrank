class AddFileLogUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :log, :string
    add_column :users, :server_log, :string
  end
end
