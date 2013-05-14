# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
 100.times do |n|
      name = "example#{n+1}"
      email = "example#{n+1}@gmail.com"
      password = "forever"
      password_confirmation = "forever"
      if(n%2 == 1)
	role = 1
	if(n%4 == 1)
	  gender = 1
	else
	  gender = 0
	end
      else 
	role = 0
	if(n%4 == 0)
	  gender = 1
	else
	  gender = 0
	end
      end
      district_id = n%18 + 1
      description = "description"
      degree_id = n%6 + 1    
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
		   role: role,
		   gender: gender,
		   district_id: district_id,
		   description: description,
		   student_visible: true,teacher_visible: true,
		   degree_id: degree_id)

      
    end

Degree.destroy_all
 degree = ["小学","初中","高中","本科","硕士","博士"]
    n = 0
    6.times do
      Degree.create!(id: n, name: degree[n])
      n = n + 1
    end

District.destroy_all
district = ["黄浦区","卢湾区","长宁区","普陀区","虹口区","闵行区","徐汇区","匣北区","杨浦区","静安区","嘉定区","宝山区","青浦区","松江区","金山区", "奉贤区", "崇明县","浦东新区"]
    n = 0
    18.times do
      District.create!(id: n, name: district[n])
      n = n + 1
    end

Subject.destroy_all
    subject = ["语文","数学","英语","物理","化学","生物","历史","地理","政治"]
    n = 0
    9.times do
      Subject.create!(name: subject[n])
      n = n + 1
    end

StudentRelationship.destroy_all
    n = 2
    50.times do 
    User.find(n).student_relationships.create!(subject_id: n%9+1)
    User.find(n).student_relationships.create!(subject_id: (n+1)%9+1)
    User.find(n).student_relationships.create!(subject_id: (n+2)%9+1)
    User.find(n).student_relationships.create!(subject_id: (n+3)%9+1)
    n = n + 2
    end

TeacherRelationship.destroy_all
    n = 1
    50.times do 
    User.find(n).teacher_relationships.create!(subject_id: (n+4)%9+1)
    User.find(n).teacher_relationships.create!(subject_id: (n+5)%9+1)
    User.find(n).teacher_relationships.create!(subject_id: (n+6)%9+1)
    User.find(n).teacher_relationships.create!(subject_id: (n+7)%9+1)
    n = n + 2
    end

