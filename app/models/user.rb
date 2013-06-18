# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  email           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)      not null
#  role            :integer          default(1), not null
#  gender          :integer
#  district_id     :integer
#  description     :string(255)
#  degree_id       :integer
#  teacher_visible :boolean          default(TRUE), not null
#  student_visible :boolean          default(TRUE), not null
#  video_url       :string(255)
#

class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :name, :password, :password_confirmation,
                  :gender, :district_id, :description, :role,
                  :student_visible, :teacher_visible, :degree_id,
                  :student_subject_ids, :teacher_subject_ids,
                  :comments_count,
                  :video_id
  attr_accessor :updating_password

  has_many :student_relationships
  has_many :student_subjects, through: :student_relationships, source: :subject
  has_many :teacher_relationships
  has_many :teacher_subjects, through: :teacher_relationships, source: :subject
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id"
  belongs_to :district
  belongs_to :degree
  
#as a student
  has_many :relationships, foreign_key: "student_id", dependent: :destroy
  has_many :teachers, through: :relationships
  has_many :room_student_relationships, foreign_key: "student_id", dependent: :destroy
  has_many :my_rooms, through: :room_student_relationships, source: :room
#as a teacher
  has_many :reverse_relationships, foreign_key: "teacher_id",class_name:"Relationship", dependent: :destroy
  has_many :students, through: :reverse_relationships
  has_many :rooms

  has_many :requests, foreign_key:"receiver_id", dependent: :destroy

  has_many :blocked_relationships,dependent: :destroy
  has_many :blocked_users, through: :blocked_relationships, source: :blocked_user
  has_many :advertisements,dependent: :destroy
  #as teacher
  has_many :comments, foreign_key: "teacher_id", dependent: :destroy
  
  scope :teacher_order, select("users.id, count(comments.id) as comments_count").joins(:comments).order("comments_count DESC")
  
  accepts_nested_attributes_for :student_subjects

  before_save { |user| user.email = email.downcase }

  validates :role, presence: true
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}

  validates :password, presence: true, length: { minimum: 7 },
            if: :should_validate_password?
  validates :password_confirmation, presence: true,
            if: :should_validate_password?
  validate :correct_video_format

  VALID_VIDEO_URL_REGEX = /\A(http:\/\/)?v\.youku\.com\/v_show\/id_(\w{13}).+\.html/
  VALID_VIDEO_ID_REGEX = /\A\w{13}\z/

  def correct_video_format
    return if self.video_id.blank?
    return if VALID_VIDEO_ID_REGEX =~ self.video_id
    if VALID_VIDEO_URL_REGEX =~ self.video_id
      self.video_id = $2
    else
      errors.add(:video_id, "格式不正确")
    end
  end

  def self.find_by_email_and_role(email, role)
    return nil unless [0, 1].include?(role)
    user = User.find_by_email(email)
    if user && (user.role == role || user.role == 2)
      return user
    end
    return nil
  end

  def should_validate_password?
    updating_password || new_record?
  end

  def full_role?
    self.role == 2
  end

  def is_student?
    self.role == 1 || self.role == 2 
  end

  def is_teacher?
    self.role == 0 || self.role == 2
  end

  def online?
    last_seen = $redis.zscore("online-users", self.id)
    return last_seen && last_seen >= 1.minute.ago.to_i
  end

  def has_blocked?(user)
    return nil if user.nil? 
    self.blocked_users.include?(user)
  end

#create 
  def have_been_friends?(other_user,current_student)
    if current_student
      self.relationships.find_by_teacher_id(other_user.id)
    else 
      self.reverse_relationships.find_by_student_id(other_user.id)
    end
  end

  def set_to_be_friends!(other_user, current_student)
    if current_student
      self.relationships.create!(teacher_id: other_user.id)
    else
      self.reverse_relationships.create!(student_id: other_user.id)
    end
  end

  def set_not_to_be_friends!(other_user, current_student)
    if current_student
      self.relationships.find_by_teacher_id(other_user.id).destroy
    else
      self.reverse_relationships.find_by_student_id(other_user.id).destroy
    end
  end

  def have_send_add_request?(other_user, current_student)
    if current_student
      other_user.requests.find_by_sender_id_and_kind(self.id, 1)
    else
      other_user.requests.find_by_sender_id_and_kind(self.id, 2)
    end
  end
  
  def update_send_add_request!(other_user, content, current_student)
    if current_student
      other_user.requests.find_by_sender_id_and_kind(self.id, 1).update_attributes(read: false, content: content)
    else
      other_user.requests.find_by_sender_id_and_kind(self.id, 2).update_attributes(read: false, content: content)
    end
  end

  def send_add_request!(other_user, content, current_student)
    if current_student
      other_user.requests.create!(sender_id: self.id, kind: 1, read: false, content: content)
    else
      other_user.requests.create!(sender_id: self.id, kind: 2, read: false, content: content)
    end
  end

  def have_add_request?(other_user, current_student)
    if current_student
      self.requests.find_by_sender_id_and_kind(other_user.id, 2)
    else
      self.requests.find_by_sender_id_and_kind(other_user.id, 1)
    end
  end

  def send_accept_request!(other_user, current_student)
    if current_student
      other_user.create_normal_request!(self.id, 3, "同意了你的请求")
    else
      other_user.create_normal_request!(self.id, 4, "同意了你的请求")
    end
  end
  def send_refuse_request!(other_user, current_student)
    if current_student
      other_user.create_normal_request!(self.id, 3, "拒绝了你的请求")
    else
      other_user.create_normal_request!(self.id, 4, "拒绝了你的请求")
    end
  end

  def delete_add_request!(other_user, current_student)
    if current_student
      self.requests.find_by_sender_id_and_kind(other_user.id, 2).destroy
    else
      self.requests.find_by_sender_id_and_kind(other_user.id, 1).destroy
    end
  end
  
  def delete_relationship!(other_user)
    if self.is_student? && other_user.is_teacher? && self.teachers.include?(other_user)
      self.set_not_to_be_friends!(other_user, true)
    end
    if self.is_teacher? && other_user.is_student? && self.students.include?(other_user)
      self.set_not_to_be_friends!(other_user, false) 
    end
  end
  def delete_request!(other_user)
    Request.find_all_by_receiver_id_and_sender_id(other_user.id, self.id).collect {|x| x.destroy}
    Request.find_all_by_receiver_id_and_sender_id(self.id, other_user.id).collect {|x| x.destroy}
  end

  def delete_relationship_and_request!(other_user)
    delete_relationship!(other_user)
    delete_request!(other_user)
  end

  def create_normal_request!(sender_id, kind, content)
    if !self.blocked_users.include?(User.find(sender_id))
      self.requests.create!(sender_id: sender_id, kind: kind, content: content)
    end
  end

  def delete_room_relationship!(other_user, current_student)
    if current_student
      other_user.rooms.each do |room|
        if room.students.include?(self)
          room.room_student_relationships.find_by_student_id(self[:id]).destroy
        end 
      end
    else
      self.rooms.each do |room|
        if room.students.include?(other_user)
          room.room_student_relationships.find_by_student_id(other_user[:id]).destroy
        end
      end
    end
  end
end
