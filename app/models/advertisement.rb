# == Schema Information
#
# Table name: advertisements
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content    :string(255)      not null
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
class Advertisement < ActiveRecord::Base
  attr_accessible :content, :role, :user_id
  belongs_to :user

  validates :content, presence: true
  validates :role, presence: true
  validates :user_id, presence: true
end
