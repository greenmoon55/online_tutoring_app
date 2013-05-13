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
#  is_student      :boolean          default(TRUE), not null
#  gender          :integer
#  district_id     :integer
#  description     :string(255)
#  visible         :boolean
#  degree_id       :integer
#

class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :name, :password, :password_confirmation,
                  :gender, :district_id, :description,
                  :student_visible, :teacher_visible, :degree_id
  attr_accessor :updating_password
  has_many :student_relationships
  has_many :student_subjects, through: :student_relationships, source: :subject
  has_many :teacher_relationships
  has_many :teacher_subjects, through: :teacher_relationships, source: :subject
  belongs_to :district

  before_save { |user| user.email = email.downcase }

  validates :name, presence: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false, scope: :role}

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
end
