class SearchContentsController < ApplicationController

  def create
    @content = params[:content]
    @gender_number = Integer( params[:gender] )
    gender_array = []
    if(@gender_number == 2)
      gender_array = [0,1]
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
    if @degree_selected.empty?
      @degree_selected = (0..5).to_a
    end
    @district_selected = []
    if(params[:district])
      params[:district].each do |single_district|
        @district_selected.push( Integer(single_district))
      end    
    end
    self.get_district
    if @district_selected.empty?
      @district_selected = (0..17).to_a
    end
    @users = User.find(:all,:conditions => ["name LIKE ? and gender IN (?) and role IN (?) and degree_id IN (?) and district_id IN (?)","%#{@content}%",gender_array,role_array,@degree_selected,@district_selected])
    render 'search'
  end
  
  def search
    @content = nil
    @gender_number = 2
    @role_number = 1
    @degree_selected = []
    @district_selected = []
    self.get_degree   
    self.get_district 
  end


  def get_degree
    @degrees = []
    name = ["小学","初中","高中","本科","硕士","博士"]
    i = 0
    6.times do
      @degrees.push(name: name[i],id:i,checked:@degree_selected.include?(i))
      i = i + 1
    end
  end
  
  def get_district
    @districts = []
    name = ["黄浦区","卢湾区","长宁区","普陀区","虹口区","闵行区","徐汇区","匣北区","杨浦区","静安区","嘉定区","宝山区","青浦区","松江区","金山区", "奉贤区", "崇明县","浦东新区"]
    i = 0
    18.times do 
      @districts.push(name: name[i],id:i,checked:@district_selected.include?(i))
      i = i + 1
    end
  end
end
