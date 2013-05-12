class SearchContentsController < ApplicationController

  def create
    @content = params[:content]
    self.get_degree
    self.get_district
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
    else 
      @degree_selected = (0..5).to_a
    end

    @district_selected = []
    if(params[:district])
      params[:district].each do |single_district|
        @district_selected.push( Integer(single_district))
      end    
    else 
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
    @degrees.push({name: "小学",id:0})
    @degrees.push({name: "初中",id:1})
    @degrees.push({name: "高中",id:2})
    @degrees.push({name: "本科",id:3})
    @degrees.push({name: "硕士",id:4})
    @degrees.push({name: "博士",id:5})
  end
  
  def get_district
    @districts = []
    @districts.push({name: "黄浦区",id:0})
    @districts.push({name: "卢湾区",id:1})
    @districts.push({name: "长宁区",id:2})
    @districts.push({name: "普陀区",id:3})
    @districts.push({name: "虹口区",id:4})
    @districts.push({name: "闵行区",id:5})
    @districts.push({name: "徐汇区",id:6})
    @districts.push({name: "匣北区",id:7})
    @districts.push({name: "杨浦区",id:8})
    @districts.push({name: "静安区",id:9})
    @districts.push({name: "嘉定区",id:10})
    @districts.push({name: "宝山区",id:11})
    @districts.push({name: "青浦区",id:12})
    @districts.push({name: "松江区",id:13})
    @districts.push({name: "金山区",id:14})
    @districts.push({name: "奉贤区",id:15})
    @districts.push({name: "崇明县",id:16})
    @districts.push({name: "浦东新区",id:17})
  end
end
