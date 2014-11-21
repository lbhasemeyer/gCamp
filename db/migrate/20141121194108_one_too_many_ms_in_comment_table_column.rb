class OneTooManyMsInCommentTableColumn < ActiveRecord::Migration
  def change
    rename_column :comments, :commment, :comment
  end
end
