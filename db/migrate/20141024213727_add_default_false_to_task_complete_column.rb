class AddDefaultFalseToTaskCompleteColumn < ActiveRecord::Migration
  def change
    change_column_default :tasks, :complete, :false
  end
end
