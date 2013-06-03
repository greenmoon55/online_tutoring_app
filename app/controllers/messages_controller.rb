# -*- encoding : utf-8 -*-
class MessagesController < ApplicationController
  before_filter :require_signin
  def create
    if params[:message][:room_id]
      # 群发消息
      room = Room.find(params[:message][:room_id])
      return unless room
      message = {
        type: 4, 
        message: {
          content: params[:message][:content],
          created_at: Time.now.to_s(:db),
          sender_id: current_user.id,
          sender_name: current_user.name
        },
        room_id: room.id
      }
      if (current_student? && room.students.includes(current_user)) ||
          (current_teacher? && current_user?(room.user))
        room.users.each do |user|
          PrivatePub.publish_to("/messages/#{user.id}", message)
        end
      end
    else
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
            content: ERB::Util.html_escape(message.content), 
            created_at: message.created_at.localtime.to_s(:db),
            user_id: message.sender_id,
            sender_name: current_user.name
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
  end
  
  def get_unread_users
    render json: (Message.find_by_sql ["SELECT * FROM messages WHERE read = 'f' AND (sender_id = ? OR receiver_id = ?)", current_user.id, current_user.id])
  end
end
