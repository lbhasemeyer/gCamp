class ChangeColumnNamePTtoken < ActiveRecord::Migration
  def change
    rename_column :users, :PTtoken, :tracker_token
  end
end
