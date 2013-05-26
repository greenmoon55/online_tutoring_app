class ChatController < ApplicationController
  before_filter :require_signin
  def new_user
    $redis.sadd(chat_userlist_key, params[:id])
  end
  def remove_user()
    $redis.srem(chat_userlist_key, params[:id])
  end
  def get_users()
    $redis.smembers(chat_userlist_key)
  end
  private
    def chat_userlist_key
      "chat-userlist-" + current_user.id.to_s
    end
end
