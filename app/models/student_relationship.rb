class StudentRelationship < ActiveRecord::Base
  attr_accessible :subject_id, :user_id

  belongs_to :subject
  belongs_to :user

  validates :subject_id, :user_id, presence: :true
  validates :user_id, :uniqueness => { scope: :subject_id }
end
