# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: relationships
#
#  id              :integer          not null, primary key
#  student_id      :integer          not null
#  teacher_id      :integer          not null
#  evaluation      :string(255)
#  is_active       :boolean          default(TRUE), not null
#  evaluation_time :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :evaluation, :evaluation_time, :is_active, :student_id, :teacher_id
  belongs_to :student, class_name: "User"
  belongs_to :teacher, class_name: "User"

  validates :student_id, presence: true
  validates :teacher_id, presence: true
  validates :is_active, presence: true

end
