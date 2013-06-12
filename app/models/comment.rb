# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  teacher_id :integer          not null
#  evaluation :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  attr_accessible :evaluation, :student_id, :teacher_id
  belongs_to :teacher, class_name: "User"
  validates :student_id, presence: true
  validates :teacher_id, presence: true
  validates :evaluation, presence: true
  default_scope order: 'comments.created_at DESC' 
end
