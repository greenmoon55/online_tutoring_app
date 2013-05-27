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

  private
    def chat_userlist_key
      "chat-userlist-" + current_user.id.to_s
    end
end
