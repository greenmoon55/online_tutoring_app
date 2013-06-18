# -*- encoding : utf-8 -*-
class RoomsController < ApplicationController
  before_filter :require_signin
  before_filter :members_in_room, only: [:show, :message]
  before_filter :correct_user, only: [:new, :index, :create, :update, :edit, :destroy]
  before_filter :room_owner, only: [:new_line, :clear]
  # post 时无需authentication token
  protect_from_forgery except: :new_line
#  before_filter :require_current_teacher,only:[:new, :index, :create,:update,:edit,:destroy]

  def new
    @room = @user.rooms.new
    @student_selected = []
    self.get_student
    @outline = nil
  end

  def index
    @rooms = @user.rooms
  end
  
  def show
    @room = Room.find(params[:id])
    @students = @room.students
  end

  def update
    @room = @user.rooms.find(params[:id])
    if params[:outline].blank?
      flash[:error] = "标题内容不能为空"
      redirect_to edit_user_room_path(current_user,params[:id]) and return 
    end
    @room.update_attributes(outline: params[:outline])
    @student_selected = []
    if params[:student]
      params[:student].each do |student_id|
        @student_selected.push(Integer(student_id))
      end
    end
    @room.room_student_relationships.each do |relationship|            
      if @student_selected.include?relationship[:student_id]
        # do nothing
      else
         if @user.students.include?(User.find(relationship[:student_id]))  
           #提醒被老师移出聊天室的学生
           User.find(relationship[:student_id]).create_normal_request!(@user[:id], 4, "将你移出了 "+ @room[:outline] + " 聊天室")
         end
         @room.room_student_relationships.find(relationship[:id]).destroy 
      end
    end
    @student_selected.each do |student_id|                            
      if @room.room_student_relationships.find_by_student_id(student_id)
        # do nothing
      else
        if @user.students.include?(User.find(student_id))
          # 提醒被老师 加入聊天室的学生
          @room.room_student_relationships.create!(student_id: student_id)  
          User.find(student_id).create_normal_request!(@user[:id], 4, "将你加入到了 " + @room[:outline] + " 聊天室中"+ "聊天室的简单介绍如下： #{params[:information]}")
        end
      end
    end
    redirect_to user_room_path(current_user, @room[:id])
  end

  def create
    if params[:outline].blank?
      flash[:error] = "标题内容不能为空"
      redirect_to new_user_room_path(current_user) and return 
    end
    @room = @user.rooms.create!(outline: params[:outline])
    @student_selected = []
    if params[:student]
      params[:student].each do |single_student_id|
        @student_selected.push(Integer(single_student_id))
        student = User.find(single_student_id)
        if @user.students.include?(student)
          # 提醒被老师 加入聊天室的学生
          @room.room_student_relationships.create!(student_id: single_student_id) 
          student.create_normal_request!(@user[:id], 4, "将你加入到了 #{@room[:outline]} 聊天室中, 聊天室的简单介绍如下： #{params[:information]}")
        end
      end
    end
    flash[:success] = "创建成功"
    redirect_to user_room_path(current_user, @room)
  end

  def edit
    @room = @user.rooms.find(params[:id])
    @outline = @room[:outline]
    @student_selected = []
    @students = @room.students
    @students.each do |student|
      @student_selected.push(Integer(student[:id]))
    end
    self.get_student
  end

  def destroy
    @room = Room.find(params[:id])
    @room.students.each do |student|
      if @user.students.include?(student)
        student.create_normal_request!(current_user[:id], 4, "解散了 "+@room[:outline]+" 聊天室")
      end
    end
    @user.rooms.find(params[:id]).destroy
    redirect_to user_rooms_path(@user)
  end
  
  # 学生自主退出聊天室
  def delete_by_student 
    @room = Room.find(params[:id])
    if current_student? && current_user.my_rooms.include?(@room)
      current_user.room_student_relationships.find_by_room_id(params[:id]).destroy
      flash[:success] = "成功退出聊天室"
    end
    redirect_to my_rooms_user_path(current_user)
  end
  
  def correct_user
    @user = User.find(params[:user_id])
    unless current_user?(@user)
      redirect_to root_path
    end
  end
  
  #获取当前用户的学生，并且增加一属性 checked 表示 是否被加入到聊天室
  def get_student
    @students = current_user.students
    @students.collect do |student|
      student[:checked] = @student_selected.include?(student[:id])
    end
  end
  
  #判断用户是否属于该聊天室
  def members_in_room
    room = Room.find(params[:id])
    #是该聊天室的老师
    if current_teacher? && current_user.rooms.include?(room)
    #是该聊天室的学生
    elsif current_student? && room.students.include?(current_user)
    else
      flash[:error] = "你没有权限"
      redirect_to current_user
    end
  end

  # 画了一条线（用于白板）
  def new_line
    PrivatePub.publish_to("/rooms/#{params[:id]}",
                          points: params[:points].values,
                          color: params[:color],
                          lineWidth: params[:lineWidth])
    render nothing: true
  end

  # 清除白板上画的内容
  def clear
    PrivatePub.publish_to("/rooms/#{params[:id]}", type: "clear")
    render nothing: true
  end

  # 只有房主才能同步白板内容给其他人
  def room_owner
    room = Room.find(params[:id])
    redirect_to root_path unless current_user?(room.user)
  end

  # 讨论组里发的消息
  def message
    message = {
      message: {
        content: ERB::Util.html_escape(params[:message][:content]),
        created_at: Time.now.to_s(:db),
        sender_id: current_user.id,
        sender_name: current_user.name
      },
      type: "message"
    }
    PrivatePub.publish_to("/rooms/#{params[:id]}", message)
    render nothing: true
  end
end
