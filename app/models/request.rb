# == Schema Information
#
# Table name: requests
#
#  id          :integer          not null, primary key
#  kind        :integer          not null
#  receiver_id :integer          not null
#  sender_id   :integer          not null
#  content     :string(255)
#  read        :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Request < ActiveRecord::Base
  attr_accessible :content, :read, :receiver_id, :sender_id, :kind
  belongs_to :receiver, class_name: "User"
  belongs_to :sender, class_name: "User"

  validates :receiver_id ,presence: true
  validates :sender_id ,presence: true
  validates :kind ,presence: true
  
end
