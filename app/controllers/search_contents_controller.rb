# -*- encoding : utf-8 -*-
class SearchContentsController < ApplicationController

  def create
    @content = params[:content]
    @gender_number = Integer( params[:gender] )
    gender_array = []
    if(@gender_number == 2)
      gender_array = [0,1,nil]
    else 
      gender_array.push(Integer(@gender_number))
    end

    @role_number = Integer(params[:role])
    role_array = [Integer(params[:role]),2]
  
    @degree_selected = []
    if(params[:degree])
      params[:degree].each do |single_degree|
        @degree_selected.push( Integer(single_degree))
      end    
    end
    self.get_degree

    degree_need_care = true
    if @degree_selected.empty?
      degrees = Degree.all
      degree_need_care = false
      degrees.each do |single_degree|
        @degree_selected.push(single_degree[:id])
      end
    end

    @district_selected = []
    if(params[:district])
      params[:district].each do |single_district|
        @district_selected.push( Integer(single_district))
      end    
    end
    district_need_care = true
    self.get_district
    if @district_selected.empty?
      district_need_care = false
      districts = District.all
      districts.each do |single_district|
        @district_selected.push(single_district[:id])
      end
    end

    @subject_selected = []
    if(params[:subject])
      params[:subject].each do |single_subject|
        @subject_selected.push( Integer(single_subject))
      end    
    end
    self.get_subject
    subject_need_care = true
    if @subject_selected.empty?
      subject_need_care = false
      subjects = Subject.all
      subjects.each do |subject|
        @subject_selected.push(subject[:id])
      end
      
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
# @users = User.find(:all,:conditions => ["name LIKE ? and gender IN (?) and role IN (?) and degree_id IN (#{@degree_selected.join(', ')}) and district_id IN (?) and #{visible} = ?  ","%#{@content}%",gender_array,role_array,@district_selected,true])
    
    if subject_need_care == true
      if(@role_number == 0)
        @users.delete_if{|user|self.help_function?( user.teacher_relationships,@subject_selected)}  
      else
        @users.delete_if{|user|self.help_function?( user.student_relationships,@subject_selected)}  
      end
    end 
    render 'search'
  end
  


  def search
    @content = nil
    @gender_number = 2
    @role_number = 1
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
