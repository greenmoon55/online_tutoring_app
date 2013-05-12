#encoding: utf-8
class SessionsController < ApplicationController
  def new
  end

  def create
    role = (params[:role] == "student")
    user = User.find_by_email_and_role(params[:email].downcase, role)
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
      flash.now[:error] = "Email或密码错误"
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to request.referer, :notice => "您已登出"
  end

end
