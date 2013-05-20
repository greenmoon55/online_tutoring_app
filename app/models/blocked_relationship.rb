class BlockedRelationship < ActiveRecord::Base
  attr_accessible :blocked_user_id, :user_id 
  belongs_to :user
  belongs_to :blocked_user, class_name: "User"

  validates :user_id, presence: true
  validates :blocked_user_id, presence: true

end
