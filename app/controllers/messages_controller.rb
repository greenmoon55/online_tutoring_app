# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :require_signin
  def create
    message = Message.new(params[:message])
    message.sender_id = current_user.id
    logger.info message.inspect
    receiver = User.find(message.receiver_id)
    if receiver && !receiver.has_blocked?(current_user)
      message.save! 
      publish_message = {type: 1, message: {content: 
          ERB::Util.html_escape(message.content), 
          created_at: message.created_at.localtime.to_s(:db),
          sender_name: current_user.name}, sender_id: message.sender_id}
      PrivatePub.publish_to("/messages/#{message.receiver_id}", publish_message)
      PrivatePub.publish_to("/messages/#{message.sender_id}", publish_message)
    else
      # 提醒发送消息的人被屏蔽啦
    end
  end
  def get_conversation(user1, user2)
    Message.find_by_sender_id_and_receiver_id(user1, user2)
  end
end
