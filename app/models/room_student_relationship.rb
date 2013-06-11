# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: room_student_relationships
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  room_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
class RoomStudentRelationship < ActiveRecord::Base
  attr_accessible :room_id, :student_id
  belongs_to :room
  belongs_to :student, class_name: "User"
  validates :room_id, presence: true
  validates :student_id, presence: true
end
