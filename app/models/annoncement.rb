class Annoncement < ActiveRecord::Base
  attr_accessible :content, :title
  
  validates :content, presence: true
  validates :title, presence: true

end
