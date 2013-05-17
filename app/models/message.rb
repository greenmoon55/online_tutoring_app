class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id 
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"

  def self.get_conversation(user1, user2)
    Message.find_by_sql ["SELECT * FROM messages WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) ORDER BY created_at", user1, user2, user2, user1]
  end
end
