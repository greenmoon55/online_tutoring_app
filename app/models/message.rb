# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  sender_id   :integer          not null
#  receiver_id :integer          not null
#  content     :string(255)
#  created_at  :datetime         not null
#

class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id 
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"

  def self.get_conversation(user1, user2)
    Message.find_by_sql ["SELECT * FROM messages WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) ORDER BY created_at", user1, user2, user2, user1]
  end

  def self.get_conversations(users, current_user)
    #Message.where(:sender_id => users, :receiver_id => users).order("created_at ASC")
    Message.find_by_sql ["SELECT * FROM messages WHERE (read = 'f' AND receiver_id = ?) OR 
      (sender_id = ? AND receiver_id IN (?)) OR (sender_id IN (?) AND receiver_id = ?) ORDER BY created_at ASC", 
      current_user.id, current_user.id, users, users, current_user.id]
  end
end 
