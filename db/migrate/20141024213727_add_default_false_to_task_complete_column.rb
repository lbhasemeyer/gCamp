class AddDefaultFalseToTaskCompleteColumn < ActiveRecord::Migration
  def change
    change_column_default :tasks, :complete, :False
  end
end
