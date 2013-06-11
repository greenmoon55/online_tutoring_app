# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: annoncements
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Annoncement < ActiveRecord::Base
  attr_accessible :content, :title
  
  validates :content, presence: true
  validates :title, presence: true

end
