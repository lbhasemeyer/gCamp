class Membership < ActiveRecord::Base

  validates :user, presence: true
  validates :user, :uniqueness => {scope: :project, message: "has already been added"}
  validates :title, presence: true

  belongs_to :user
  belongs_to :project

  before_destroy :cannot_delete_last_owner

  def owner
    project.memberships.where(title: "Owner")
  end

  def cannot_delete_last_owner
    if owner.count == 1 && title == "Owner"
      return false
    end
  end

end
