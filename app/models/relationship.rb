class Relationship < ActiveRecord::Base
  attr_accessible :evaluation, :evaluation_time, :is_active, :student_id, :teacher_id
  belongs_to :student, class_name: "User"
  belongs_to :teacher, class_name: "User"

  validates :student_id, presence: true
  validates :teacher_id, presence: true
  validates :is_active, presence: true

end
