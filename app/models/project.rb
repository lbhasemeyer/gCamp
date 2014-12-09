class Project < ActiveRecord::Base

    validates :name, presence: true

    has_many :tasks, dependent: :delete_all
    has_many :memberships, dependent: :delete_all
    has_many :users, through: :memberships

end
