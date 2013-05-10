class SearchContentsController < ApplicationController

  def create
    @content = params[:search_content][:content]

    @users = User.find(:all,:conditions => ['name LIKE ?',"%#{@content}%"])
#    @users = User.all
    @students = [] 
    @teachers = [] 

    if @users
      @users.each do |user|
        if user.is_student
          @students.push(user)
        else
          @teachers.push(user)
        end
      end
    end
    render 'search'
  end
  
  def search
    @content = nil
  end
end
