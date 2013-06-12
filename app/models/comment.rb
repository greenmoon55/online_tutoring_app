class Comment < ActiveRecord::Base
  attr_accessible :evaluation, :student_id, :teacher_id
  belongs_to :teacher, class_name: "User"
  validates :student_id, presence: true
  validates :teacher_id, presence: true
  validates :evaluation, presence: true
  default_scope order: 'comments.created_at DESC' 
end
