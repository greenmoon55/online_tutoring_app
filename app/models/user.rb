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
#
class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :name, :password, :password_confirmation,
                  :gender, :district_id, :description,:role,
                  :student_visible, :teacher_visible, :degree_id,
                  :student_subject_ids, :teacher_subject_ids
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
  has_many :teachers, through: :relationships,dependent: :destroy
#as a teacher
  has_many :reverse_relationships, foreign_key: "teacher_id",class_name:"Relationship", dependent: :destroy
  has_many :students, through: :reverse_relationships,dependent: :destroy

  has_many :requests, foreign_key:"receiver_id", dependent: :destroy

  accepts_nested_attributes_for :student_subjects

  before_save { |user| user.email = email.downcase }

  validates :name, presence: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}

  validates :password, presence: true, length: { minimum: 7 },
            if: :should_validate_password?
  validates :password_confirmation, presence: true,
            if: :should_validate_password?

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

  def current_student?
    SessionsController.helpers.current_student?
  end

  def following?(other_user)
    if current_student?
      self.relationships.find_by_teacher_id(other_user.id)
    else 
      self.reverse_relationships.find_by_student_id(other_user.id)
    end
  end

  def follow!(other_user)
    if current_student?
      self.relationships.create!(teacher_id: other_user.id)
    else
      self.reverse_relationships.create!(student_id: other_user.id)
    end
  end

  def unfollow!(other_user)
    if current_student?
      self.relationships.find_by_teacher_id(other_user.id).destroy
    else
      self.reverse_relationships.find_by_student_id(other_user.id).destroy
    end
  end

  def send_add_request?(other_user)
    if current_student?
      other_user.requests.find_by_sender_id_and_type(self.id,1)
    else
      other_user.requests.find_by_sender_id_and_type(self.id,3)
    end
  end


  def send_refuse_request?(other_user)
    if current_student?
      other_user.requests.find_by_sender_id_and_type(self.id,2)
    else
      other_user.requests.find_by_sender_id_and_type(self.id,4)
    end
  end

  def send_add_request!(other_user,content)
    if current_student?
      other_user.requests.create!(sender_id: self.id, type:1, content:content)
    else
      other_user.requests.create!(sender_id: self.id, type:3, content:content)
    end
  end

  def send_refuse_request!(other_user,content)
    if current_student?
      other_user.requests.create!(sender_id: self.id, type:2, content:content)
    else
      other_user.requests.create!(sender_id: self.id, type:4, content:content)
    end
  end




end
