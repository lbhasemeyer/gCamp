class Comment < ActiveRecord::Base

  validates :comment, presence: true
  belongs_to :task
  belongs_to :user

end
