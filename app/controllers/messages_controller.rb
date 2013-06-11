# -*- encoding : utf-8 -*-
class MessagesController < ApplicationController
  before_filter :require_signin
  def create
    message = Message.new(params[:message])
    message.sender_id = current_user.id
    receiver = User.find(message.receiver_id)
    return unless receiver
    if !receiver.has_blocked?(current_user)
      message.save! 
      publish_message = {
        type: 1, 
        message: 
        {
          id: message.id,
          content: ERB::Util.html_escape(message.content), 
          created_at: message.created_at.localtime.to_s(:db),
          user_id: message.sender_id,
          sender_name: current_user.name,
          sender_id: message.sender_id,
          read: message.read
        }
      }
      PrivatePub.publish_to("/messages/#{message.receiver_id}", publish_message)
      publish_message[:message][:user_id] = message.receiver_id
      PrivatePub.publish_to("/messages/#{message.sender_id}", publish_message)
    else
      # 提醒发送消息的人被屏蔽啦
      PrivatePub.publish_to("/messages/#{message.sender_id}", {type: 5})
    end
  end

  def read
    Message.where("receiver_id = ? AND id <= ?", current_user.id, params[:id].to_i).update_all(read: true)
    render nothing: true
  end
end
