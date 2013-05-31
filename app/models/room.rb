# -*- encoding : utf-8 -*-
class Room < ActiveRecord::Base
  attr_accessible :outline, :user_id
  belongs_to :user
  has_many :room_student_relationships,dependent: :destroy
  has_many :students,through: :room_student_relationships

  validates :user_id, presence: true

  def users
    #self.students + 
  end
end
