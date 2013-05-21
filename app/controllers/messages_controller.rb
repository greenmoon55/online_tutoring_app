# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :require_signin
  def create
    message = Message.new(params[:message])
    message.sender_id = current_user.id
    message.save!
    PrivatePub.publish_to("/messages/#{message.receiver_id}",
        message: message)
    PrivatePub.publish_to("/messages/#{message.sender_id}",
        message: message)
  end
  def get_conversation(user1, user2)
    Message.find_by_sender_id_and_receiver_id(user1, user2)
  end
end
