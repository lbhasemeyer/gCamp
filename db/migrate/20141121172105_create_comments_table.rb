class CreateCommentsTable < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :commment
      t.belongs_to :tasks
      t.belongs_to :users

      t.timestamps
    end
  end
end
