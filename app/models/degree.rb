# == Schema Information
#
# Table name: degrees
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Degree < ActiveRecord::Base
  attr_accessible :name
  has_many :users
end
