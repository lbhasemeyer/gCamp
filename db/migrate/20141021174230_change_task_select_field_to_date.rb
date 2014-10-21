class ChangeTaskSelectFieldToDate < ActiveRecord::Migration
  def change
    rename_column :tasks, :select, :date
  end
end
