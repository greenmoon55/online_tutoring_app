# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: districts
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

class District < ActiveRecord::Base
  attr_accessible :name
  has_many :users
end
