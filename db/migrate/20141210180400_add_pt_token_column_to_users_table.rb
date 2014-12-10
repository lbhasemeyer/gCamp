class AddPtTokenColumnToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :PTtoken, :string
  end
end
