class RequestsController < ApplicationController
  before_filter :require_signin , only:[:create,:destroy,:delete_request]
  def create
    @content = params[:content]
    @receiver = User.find(params[:receiver_id])

    if current_user.have_been_friends?(@receiver,current_student?)
      flash[:error] = "已经成为朋友"
      redirect_to current_user and return
     #have been friends
    end

    if current_user.have_add_request?(@receiver,current_student?)
      flash[:error] = "他已经给你发出请求"
      redirect_to current_user and return
    #there is an add request from receiver
    #so need not create a add request
    end

    if current_user.have_send_add_request?(@receiver,current_student?)
      current_user.update_send_add_request!(@receiver,@content,current_student?)
      flash[:error] = "已经发了请求，只是更新一下"
      redirect_to current_user and return
    #have sent an add request just update it
    else

      current_user.send_add_request!(@receiver,@content,current_student?)
      flash[:success] = "发送成功"
      redirect_to @receiver and return
      #just send a request
    end
  end


  def destroy
    sender_id = params[:sender_id]
    @sender = User.find(sender_id)
    unless current_user.have_add_request?(@sender,current_student?)
      flash[:error] = "这个请求不存在"
      redirect_to current_user     and return 
      #request not exist  
    end
    
    current_user.send_refuse_request!(@sender,current_student?)
    current_user.delete_add_request!(@sender,current_student?)
    #delete successfully
      flash[:success] = "拒绝成功"
      redirect_to current_user     and return 
  end

  def delete_request
    request_id = params[:request_id]
    unless Request.find(request_id)
      flash[:error] = "已删除该消息"
      redirect_to current_user and return
    end
    current_user.requests.find(request_id).destroy
    flash[:success] = "成功删除消息"
    redirect_to current_user and return 
  end
end