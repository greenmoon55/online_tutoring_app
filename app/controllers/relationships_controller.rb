# -*- encoding : utf-8 -*-
class RelationshipsController < ApplicationController
  before_filter :require_signin
  def create
    sender_id = params[:sender_id]
    @sender = User.find(sender_id)
    unless current_user.have_add_request?(@sender,current_student?)
      flash[:error] = "这个请求不存在"
      redirect_to requests_user_path(current_user) and return
          #request not exist  
    end
    if current_user.have_been_friends?(@sender,current_student?)
      flash[:error] ="已经加为好友啦"
      redirect_to requests_user_path(current_user) and return
      #have been friends
    end
    if @sender.blocked_users.include?(current_user)
      flash[:error]="不好意思，#{@sender.name}已经将你列入黑名单了"
      current_user.delete_add_request!(@sender,current_student?)
      redirect_to requests_user_path(current_user) and return 
    end
    
    current_user.send_accept_request!(@sender,current_student?)
    current_user.delete_add_request!(@sender,current_student?)
    current_user.set_to_be_friends!(@sender,current_student?)
    flash[:sucess] = "成功将#{@sender.name}加为好友"
    redirect_to requests_user_path(current_user) and return
    
  end
  def destroy
    user_id = params[:user_id]
    @user = User.find(user_id)
    if !current_user.have_been_friends?(@user,current_student?)
      flash[:error] = "你们已经解除了好友关系"
      redirect_to current_user and return
    else
      flash[:success] = "解除成功"
      current_user.delete_room_relationship!(@user,current_student?)
      current_user.set_not_to_be_friends!(@user,current_student?)
      redirect_to current_user and return
    end
  end
end
