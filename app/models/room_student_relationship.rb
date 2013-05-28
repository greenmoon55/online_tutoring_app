# -*- encoding : utf-8 -*-
class RoomStudentRelationship < ActiveRecord::Base
  attr_accessible :room_id, :student_id
  belongs_to :room
  belongs_to :student, class_name: "User"
  validates :room_id, presence: true
  validates :student_id, presence: true
end
