class User < ActiveRecord::Base

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships
  has_many :comments, dependent: :nullify

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_owner?(project)
    project.memberships.where(title: 'Owner', user_id: id).present?
  end

  def is_member?(project)
    projects.include?(project)
  end

  def is_co_project_with?(user)
    (projects & user.projects).present?
  end

end
