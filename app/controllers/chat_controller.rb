# -*- encoding : utf-8 -*-
class ChatController < ApplicationController
  before_filter :require_signin
  def new_user
    $redis.sadd(chat_userlist_key, params[:id])
    render :nothing => true
  end

  def remove_user()
    $redis.srem(chat_userlist_key, params[:id])
    render :nothing => true
  end

  # 打开聊天窗口时返回用户列表
  def get_users()
    uids = $redis.smembers(chat_userlist_key)
    uids.map! { |x|
      {id: x, name: User.find(x).name}
    }
    render json: {users: uids}
  end

  def get_conversation
    messages = Message.get_conversation(current_user.id, params[:id])
    name_hash = {current_user.id => current_user.name, 
      params[:id].to_i => User.find(params[:id]).name}
    logger.info name_hash.inspect
    messages.map! do |m|
        {content: ERB::Util.html_escape(m.content), 
        created_at: m.created_at.localtime.to_s(:db),
        user_id: params[:id],
        sender_name: name_hash[m.sender_id],
        sender_id: m.sender_id}
    end
    render json: messages
  end

  def get_conversations
    params[:users] << current_user.id
    messages = Message.get_conversations(params[:users])
    messages.map! do |m|
        {content: ERB::Util.html_escape(m.content), 
        created_at: m.created_at.localtime.to_s(:db),
        user_id: (m.sender_id == current_user.id)? m.receiver_id : m.sender_id,
        sender_name: User.find(m.sender_id).name,
        sender_id: m.sender_id}
    end
    render json: messages
  end
  private
    def chat_userlist_key
      "chat-userlist-" + current_user.id.to_s
    end
end
