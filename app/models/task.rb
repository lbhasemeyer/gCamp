class Task < ActiveRecord::Base

  validates :description, presence: true
  validates_datetime :starts_at, :after => :now
end
