class RoomsController < ApplicationController
  before_filter :require_signin
  before_filter :members_in_room,only:[:show]
  before_filter :correct_user,only:[:new, :index, :create,:update,:edit,:destroy]
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
    @user = User.find(params[:user_id])
    @room = @user.rooms.find(params[:id])
    @students = @room.students

  end

  def update
    @room = @user.rooms.find(params[:id])
    @room.update_attributes(outline: params[:outline])
    @student_selected = []
    params[:student].each do |student_id|
      @student_selected.push(Integer(student_id))
    end
    @room.room_student_relationships.each do |relationship|
      if @student_selected.include?relationship[:student_id]
        # do nothing
      else
         if @user.students.include?(User.find(relationship[:student_id]))
            User.find(relationship[:student_id]).requests.create!(kind:4,sender_id:@user[:id], content: "将你移出了 "+ @room[:outline] + " 聊天室中")
         end
         @room.room_student_relationships.find(relationship[:id]).destroy
        
      end
    end

    @student_selected.each do |student_id|
      if @room.room_student_relationships.find_by_student_id(student_id)
        # do nothing
      else
        if @user.students.include?(User.find(student_id))
          @room.room_student_relationships.create!(student_id: student_id)
          User.find(student_id).requests.create!(kind:4,sender_id:@user[:id],content: "将你加入到了 " + @room[:outline] + " 聊天室中")
        end
      end
    end
    redirect_to user_room_path(current_user,@room[:id])
  end

  def create
    @room = @user.rooms.create!(outline: params[:outline])
    @student_selected = []
    params[:student].each do |single_student_id|
      @student_selected.push(Integer(single_student_id))
      student = User.find(single_student_id)
      if @user.students.include?(student)
        @room.room_student_relationships.create!(student_id: single_student_id)
        student.requests.create!(sender_id:@user[:id],kind:4,content: "将你加入到了 " + @room[:outline] + " 聊天室中")
      end
    end
    flash[:success] = "创建成功"
    redirect_to current_user
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
    @room =Room.find(params[:id])
    @room.students.each do |student|
      if @user.students.include?(student)
        student.requests.create!(sender_id:current_user[:id],content: "解散了 "+@room[:outline]+" 聊天室", kind:4)
      end
    end
    @user.rooms.find(params[:id]).destroy
    redirect_to user_rooms_path(@user)

  end

    def correct_user
      @user = User.find(params[:user_id])
      unless current_user?(@user)
        redirect_to root_path, notice: "非法操作"
      end
    end
    def get_student
      @students = current_user.students
      @students.collect do |student|
        student[:checked] = @student_selected.include?(student[:id])
      end
    end
  def members_in_room
    user_id = params[:user_id]
    room_id = params[:id]
    if current_user?(User.find(user_id)) && current_teacher? && current_user.rooms.include?(Room.find(room_id))
#  elsif current_student? && Room.find(room_id).students.include?(current_user)
    elsif !current_user?(User.find(user_id)) && current_student? && Room.find(room_id).students.include?(current_user)
    else
    flash[:error] = "you don't have access"
    redirect_to current_user
    end
  end
end
