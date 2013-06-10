# -*- encoding : utf-8 -*-
class BlockedRelationshipsController < ApplicationController
  before_filter :require_signin
  def create
    blocked_user_id = params[:blocked_user_id]
    blocked_user = User.find(params[:blocked_user_id])
    if current_user.blocked_relationships.find_by_blocked_user_id(blocked_user_id)     
      flash[:error] = "已经将#{blocked_user.name}加入到了你的黑名单中"  
      redirect_to blocked_user and return
    else
      current_user.delete_relationship_and_request!(blocked_user)                  #delete relationships and request between current_user and blocked_user
      current_user.delete_room_relationship!(blocked_user, current_student?)       #delele room_relationships
      current_user.blocked_relationships.create!(blocked_user_id: blocked_user_id) #add blocked_relationships 
      flash[:success] = "成功将#{blocked_user.name}加入了黑名单"
      redirect_to blocked_user and return
    end
  end
  
  def destroy
    blocked_user_id = params[:blocked_user_id]
    blocked_user = User.find(blocked_user_id)
    if !current_user.blocked_relationships.find_by_blocked_user_id(blocked_user_id)
      flash[:error] = "#{blocked_user.name} 不在你的黒名单中"
      redirect_to blocked_user and return
    end
    current_user.blocked_relationships.find_by_blocked_user_id(blocked_user_id).destroy
    flash[:success] = "已将#{blocked_user.name}移出黑名单"
    redirect_to blocked_user and return
  end
end
