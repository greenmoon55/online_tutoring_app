class Request < ActiveRecord::Base
  attr_accessible :content, :read, :receiver_id, :sender_id, :type
  belongs_to :receiver, class_name: "User"
  belongs_to :sender, class_name: "User"

  validates :receiver_id ,presence: true
  validates :sender_id ,presence: true
  validates :type ,presence: true
  validates :read ,presence: true
  
end
