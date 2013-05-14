# == Schema Information
#
# Table name: subjects
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

class Subject < ActiveRecord::Base
  attr_accessible :name
end
