class User < ActiveRecord::Base

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email.downcase, presence: true, uniqueness: true
  has_secure_password

end
