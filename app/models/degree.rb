# == Schema Information
#
# Table name: degrees
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Degree < ActiveRecord::Base
  attr_accessible :name
  has_many :users
end
