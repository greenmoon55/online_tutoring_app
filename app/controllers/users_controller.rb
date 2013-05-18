# encoding: utf-8
class UsersController < ApplicationController
  before_filter :require_signin, only: [:edit, :update, :destroy, :full_role]
  before_filter :correct_user,   only: [:edit, :update, :destroy, :full_role,:requests]

  def new
    @user = User.new
  end

  def create
    role = (params[:user][:role] == "student")
    params[:user].delete :role
    @user = User.new(params[:user])
    @user.role = (role ? 1 : 0)
    if @user.save
      flash[:success] = "注册成功，请完善个人资料!"
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @messages = Message.get_conversation(@user.id, current_user.id)
    logger.info "show"
    logger.info @user.id
    logger.info current_user.id
  end

  def edit
    @user = User.find(params[:id])
    logger.info current_role
    logger.info "in edit"
    if current_teacher?
      logger.info "here"
      render "edit_teacher"
      return
    end
    logger.info current_role
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:current_password] 
      if @user.authenticate(params[:user][:current_password])
        @user.updating_password = true # RailsCasts #41
        params[:user].delete :current_password
      else
        flash.now[:error] = "当前密码错误"
        render 'edit' and return
      end
    else
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: '编辑成功'
    else
      render 'edit'
    end
  end

  def full_role
    @user = User.find(params[:id])
    @user.role = 2 #0老师 1学生 2既是老师也是学生
    @user.save!
    redirect_to @user
  end
  
  def search
    
  end

  def messages
    user = User.find(params[:id])
    @messages = user.received_messages
  end
  
  def friends
    @title = "所有朋友"
    @user = User.find(params[:id])
    if current_student?
      @users = @user.teachers
    else
      @users = @user.students
    end
    render 'show_friends'
  end

  def requests
    @title = "所用请求"
    @user = User.find(params[:id])
    if current_student?
      @requests = @user.requests.find_all_by_kind(2)
    else
      @requests = @user.requests.find_all_by_kind(1)
    end
    render 'show_requests'
  end


 

  private
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to root_path, notice: "非法操作"
      end
    end

end
