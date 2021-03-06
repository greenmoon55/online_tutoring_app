# -*- encoding : utf-8 -*-
class SearchContentsController < ApplicationController
  def create
    @content = params[:content]
    @gender_number = Integer(params[:gender])
    gender_array = []
    if(@gender_number == 2)
      gender_array = [0,1,nil]
    else 
      gender_array.push(Integer(@gender_number))
    end

    @role_number = Integer(params[:role])   
    # 这行没使用，所以注释了
    #role_array = [Integer(params[:role]),2]
  
    @degree_selected = []
    if(params[:degree])
      params[:degree].each do |single_degree|
        @degree_selected.push(Integer(single_degree))
      end    
    end

    #获取所有degree，加入 checked 的属性
    self.get_degree
    degree_need_care = true 
    if @degree_selected.empty?
      degree_need_care = false
    end

    @district_selected = []
    if(params[:district])
      params[:district].each do |single_district|
        @district_selected.push( Integer(single_district))
      end    
    end
    district_need_care = true

    #获取所有district，加入 checked 的属性
    self.get_district 
    if @district_selected.empty?
      district_need_care = false
    end

    @subject_selected = []   
    if params[:subject]
      params[:subject].each do |single_subject|
        @subject_selected.push(Integer(single_subject))
      end
    end

    #获取所有subject，加入 checked 的属性
    self.get_subject
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
      #condition += " and teacher_visible = ? "
      condition += " and teacher_visible = :visible "
    else 
      #condition += " and student_visible = ? "
      condition += " and student_visible = :visible "
    end
    
    #condition += " and (name LIKE ? or description LIKE ?) "
    condition += " and (name LIKE :justcontent or description LIKE :justcontent) "

    if subject_need_care
      if @role_number == 0
        teacher_ids = "select users.id from users, teacher_relationships where users.id = teacher_relationships.user_id and teacher_relationships.subject_id IN (#{@subject_selected.join(', ')})"
        condition += "and users.id IN (#{teacher_ids}) "
      else
        student_ids = "select users.id from users, student_relationships where users.id = student_relationships.user_id and student_relationships.subject_id IN (#{@subject_selected.join(', ')})"
        condition += "and users.id IN (#{student_ids}) "
      end
    end
    #comments_count = "count (*) from select user desc" .order("(select  users.id, count(users.id) from users, comments where users.id = comments.teacher_id) desc")
    #order_condition = " (select count(teacher_id) as teacher_count from comments, users where comments.teacher_id = users.id group by teacher_id) desc"
    #@users = User.paginate(:conditions => [condition,true,"%#{@content}%","%#{@content}%"], :page => params[:page], :per_page => 5).order( order_condition)
    sql = "select users.*, count(teacher_id) as teachers_count from users, comments where users.id = comments.teacher_id and " + condition + " group by users.id "
    sql2 = " union select  users.*,0 as teachers_count from users where " + condition 
    sql3 = " except select users.*,0 as teachers_count from users, comments where users.id = comments.teacher_id order by teachers_count desc"
    if @role_number == 0 
      @users = User.paginate_by_sql([sql+sql2+sql3, visible: true, justcontent: "%#{@content}%"], :page => params[:page], :per_page => 5)
    else
      @users = User.paginate(:conditions => [condition,visible: true, justcontent: "%#{@content}%"], :page => params[:page], :per_page => 5)
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


  #获取所有degree，并且增加一属性 checked 表示在view中是否被选择，以下类似
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
