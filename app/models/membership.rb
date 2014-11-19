class Membership < ActiveRecord::Base

  validates :user, presence: true
  validates :user, :uniqueness => {scope: :project, message: "has already been added"}
  validates :title, presence: true

  belongs_to :user
  belongs_to :project

end
