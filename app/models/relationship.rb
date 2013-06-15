# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  teacher_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
class Relationship < ActiveRecord::Base
  attr_accessible :student_id, :teacher_id
  belongs_to :student, class_name: "User"
  belongs_to :teacher, class_name: "User"

  validates :student_id, presence: true
  validates :teacher_id, presence: true

end
