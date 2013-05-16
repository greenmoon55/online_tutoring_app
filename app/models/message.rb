class Message < ActiveRecord::Base
  attr_accessible :content, :integer, :receiver_id, :sender_id
end
