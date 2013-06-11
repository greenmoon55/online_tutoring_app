# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
#  before_filter :require_signin, only: [:edit, :update, :destroy, :full_role]
  before_filter :correct_user, only: [:edit, :update, :destroy, :full_role, :requests, :friends]
  before_filter :require_signin, only: :correct_user

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
  end

  def edit
    @user = User.find(params[:id])
    if current_teacher?
      render "edit_teacher"
      return
    end
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

  def messages
    user = User.find(params[:id])
    @messages = user.received_messages
  end
  
  def friends
    user = User.find(params[:id])
    if current_student?
      @title = "我的导师"
      @users = user.teachers
    else
      @title = "我的学生"
      @users = user.students
    end
  end

  def requests
    @title = "所有请求"
    @user = User.find(params[:id])
    if current_student?
      @user.requests.find_all_by_kind_and_read([2,4],false).collect do |x| x.update_attributes(read: true) end
      @add_requests = @user.requests.find_all_by_kind(2)
      @other_requests = @user.requests.find_all_by_kind(4)
    else
      @add_requests = @user.requests.find_all_by_kind(1)
      @user.requests.find_all_by_kind_and_read([1,3],false).collect do |x| x.update_attributes(read: true) end
      @other_requests = @user.requests.find_all_by_kind(3)
    end
  end

  def blocked_users
    @title = "黑名单列表"
    @user = User.find(params[:id])
    @blocked_users = @user.blocked_users
  end
 
  def my_rooms
    if current_student?
      @title = "我的聊天室"
      @student = User.find(params[:id])
      @rooms = []
      Room.all.each do |room|
        if room.students.include? @student
          @rooms.push(room)
        end
      end
    end
    render 'rooms/index'
  end

  private
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to root_path, notice: "非法操作"
      end
    end

end
