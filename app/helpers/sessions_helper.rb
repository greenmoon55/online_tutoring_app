# -*- encoding : utf-8 -*-
module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
    session[:role] = (user.role == 1)
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def require_signin
    unless signed_in?
      respond_to do |format|
        format.html { redirect_to signin_path, notice: "请先登录" }
        format.js {render :js => "alert('请先登录');"}
      end
    end
  end
  
  def require_admin
    unless signed_in? && current_user[:id] == 1
        flash[:error] = "你没有权限"
        redirect_to root_path
    end
  end
  
  def current_admin?
    signed_in? && current_user[:id] == 1
  end
  
  def require_current_teacher
    unless signed_in?&&current_teacher?
      redirect_to root_path
    end
  end
  # setter
  def current_user=(user)
    @current_user = user
  end

  # getter
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
    @current_user
  end

  def current_user?(user)
    user == current_user
  end

  # setter
  def current_role=(role)
    @current_role = role
  end

  # getter
  def current_role
    if session.has_key?(:role)
      @current_role ||= session[:role]
    end
    return @current_role
  end

  def current_role_to_s
    unless current_role
      return "教师"
    else
      return "学生" 
    end
  end

  # 当前登录的身份是否为教师
  def current_teacher?
    self.current_role == false
  end

  def current_student?
    self.current_role == true
  end

  def sign_out
    self.current_user = nil
    session.delete(:user_id)
    session.delete(:role)
    cookies.delete(:userList)
  end

  def current_user_role_number
    if current_student?
      return 1
    else 
      return 0
    end
  end

  def districts
    @districts ||= District.all.collect {|x| [x.name, x.id]}
  end

  def degrees
    @degrees ||= Degree.all.collect {|x| [x.name, x.id]}
  end

end
