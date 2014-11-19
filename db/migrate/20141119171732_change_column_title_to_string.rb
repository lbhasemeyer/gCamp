class ChangeColumnTitleToString < ActiveRecord::Migration
  def change
    change_column :memberships, :title, :string
  end
end
