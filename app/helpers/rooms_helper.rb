module RoomsHelper
  def members_in_room
    user_id = params[:user_id]
    room_id = params[:id]
    if current_user?(User.find(user_id)) && current_teacher? && current_user.rooms.include?(Room.find(room_id))
    
    elsif !current_user?(User.find(user_id)) && current_student? && Room.find(room_id).students.include?(User.find(user_id))
    else
      flash[:error] = "you don't have access"
      redirect_to current_user
    end
  end

end
