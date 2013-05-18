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
end
