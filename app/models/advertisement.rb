class Advertisement < ActiveRecord::Base
  attr_accessible :content, :role, :user_id
  belongs_to :user

  validates :content, presence: true
  validates :role, presence: true
  validates :user_id, presence: true
end
