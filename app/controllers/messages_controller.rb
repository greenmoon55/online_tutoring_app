# encoding: utf-8
class MessagesController < ApplicationController
  def create
    message = Message.new(params[:message])
    message.sender_id = current_user.id
    message.save!
    PrivatePub.publish_to("/messages/#{message.receiver_id}",
      "$(\"#chat\").append(\"#{message.content}\");");
    PrivatePub.publish_to("/messages/#{message.sender_id}",
      "$(\"#chat\").append(\"#{message.content}\");");
  end
  def get_conversation(user1, user2)
    Message.find_by_sender_id_and_receiver_id(user1, user2)
  end
end
