class CreateMembershipsTable < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :user
      t.belongs_to :project
      t.boolean :title
    end
  end
end
