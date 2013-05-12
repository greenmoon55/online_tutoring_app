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
  attr_accessible :email, :name, :password, :password_confirmation,
                  :role, :gender, :district_id, :description,
                  :visible, :degree_id
  belongs_to :district
  has_secure_password

  before_save { |user| user.email = email.downcase }

  validates :name, presence: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false, scope: :role}

  validates :password, presence: true, length: { minimum: 7 }
  validates :password_confirmation, presence: true

  def find_by_email_and_role(email, role)
    return nil unless [0, 1].include?(role)
    user = User.find_by_email(email)
    if user && (user.role == role || user.role == 2)
      return user
    end
    return nil
  end
end
