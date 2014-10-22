class ChangeDueToDueDate < ActiveRecord::Migration
  def change
    rename_column :tasks, :date, :due_date
  end
end
