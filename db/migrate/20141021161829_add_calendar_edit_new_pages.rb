class AddCalendarEditNewPages < ActiveRecord::Migration
  def change
    add_column :tasks, :select, :date
  end
end
