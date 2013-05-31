# -*- encoding : utf-8 -*-
class Room < ActiveRecord::Base
  attr_accessible :outline, :user_id
  belongs_to :user
  has_many :room_student_relationships,dependent: :destroy
  has_many :students, through: :room_student_relationships

  validates :user_id, presence: true

  # 房间的所有人员
  def users
    # 一定要dup, 否则就会修改数据库
    self.students.dup << self.user
  end
end
