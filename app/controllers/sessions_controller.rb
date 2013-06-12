# -*- encoding : utf-8 -*-
#encoding: utf-8
class SessionsController < ApplicationController
  before_filter :require_signin, only: :refresh
  def new
  end

  def create
    role = (params[:role] == "student")
    user = User.find_by_email_and_role(params[:email].downcase, role ? 1 : 0)
    if user && user.authenticate(params[:password])
#      if params[:remember_me]
#        cookies.permanent[:remember_token] = user.remember_token
#      else
        session[:user_id] = user.id
        session[:role] = role
#      end
      self.current_user = user
      #logger.info user
      redirect_to root_url
    else
      flash.now[:error] = "Email、密码或身份错误"
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to request.referer, :notice => "您已登出"
  end

  def refresh
    return unless signed_in?
    # key, score, member
    $redis.zadd('online-users', Time.now.to_i, current_user.id) 
    uids = params[:users] || []
    uids.map!(&:to_i)
    uids.keep_if {|uid| User.find(uid).online?} 
    chatroom_students = params[:chatroomStudents] || []
    chatroom_students.map!(&:to_i)
    chatroom_students.keep_if {|uid| User.find(uid).online?}
    render :json => {uids: uids, chatroomStudents: chatroom_students}
  end
end
