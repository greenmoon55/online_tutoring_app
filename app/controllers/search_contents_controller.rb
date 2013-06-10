# -*- encoding : utf-8 -*-
class SearchContentsController < ApplicationController

  def create
    @content = params[:content]                    #search content
    @gender_number = Integer(params[:gender])      #gender
    gender_array = []
    if(@gender_number == 2)
      gender_array = [0,1,nil]
    else 
      gender_array.push(Integer(@gender_number))
    end

    @role_number = Integer(params[:role])          #role
    role_array = [Integer(params[:role]),2]
  
    @degree_selected = []       #selected degree
    if(params[:degree])
      params[:degree].each do |single_degree|
        @degree_selected.push(Integer(single_degree))
      end    
    end
    self.get_degree             # set attribute "checked"  of degree according to selected degree 
    degree_need_care = true 
    if @degree_selected.empty?
      degree_need_care = false
    end

    @district_selected = []    # selected district
    if(params[:district])
      params[:district].each do |single_district|
        @district_selected.push( Integer(single_district))
      end    
    end
    district_need_care = true
    self.get_district          # set attribute "checked"  of district according to selected degree 
    if @district_selected.empty?
      district_need_care = false
    end

    @subject_selected = []     # selected subject   
    if(params[:subject])
      params[:subject].each do |single_subject|
        @subject_selected.push(Integer(single_subject))
      end
    end
    self.get_subject           # set attribute "checked"  of subject according to selected degree 
    subject_need_care = true
    if @subject_selected.empty?
      subject_need_care = false
    end
    condition = ""

    if @role_number == 0
      condition += "role IN (0,2)"
    else
      condition += "role IN (1,2)"
    end
    if @gender_number != 2
      condition += " and gender = #{@gender_number}"
    end 
    if degree_need_care
      condition += " and degree_id IN (#{@degree_selected.join(', ')})"
    end
    if district_need_care
      condition += " and district_id IN (#{@district_selected.join(', ')})"
    end
    if @role_number == 0
      condition += " and teacher_visible = ? "
    else 
      condition += " and student_visible = ? "
    end
    condition += " and name LIKE ?"
    @users = User.find(:all,:conditions => [condition,true,"%#{@content}%"])
    if subject_need_care 
      if @role_number == 0
        @users.delete_if{|user|self.help_function?(user.teacher_relationships,@subject_selected)}  
      else
        @users.delete_if{|user|self.help_function?(user.student_relationships,@subject_selected)}  
      end
    end 
    render 'new'
  end
  
  
  def index
    redirect_to search_path
  end


  def new
    @content = nil
    @gender_number = 2
    @role_number = 1
    if signed_in? && current_student?
      @role_number = 0
    end
    @degree_selected = []
    @district_selected = []
    @subject_selected = []
    self.get_degree   
    self.get_district 
    self.get_subject
  end


  def help_function?(array1 ,array2)
    array2.each do |element|
      if array1.find_by_subject_id(element)
        return false
      end
    end
   return true
  end

  #获取所有degree， 并且增加一属性 checked 表示在view中是否被选择， 以下类似
  def get_degree     
    @degrees = Degree.all
    @degrees.collect do|degree|
      degree[:checked] = @degree_selected.include?(degree[:id])
    end
  end
  
  def get_district
    @districts =District.all
    @districts.collect do |district| 
      district[:checked] = @district_selected.include?(district[:id])
    end
  end

  def get_subject
    @subjects = Subject.all
    @subjects.collect do |subject|
      subject[:checked] = @subject_selected.include?(subject[:id])
    end
  end

end
