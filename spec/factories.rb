<<<<<<< HEAD
FactoryGirl.define do 
	factory :user do
		name "aaa"
		email "zxcv@qq.com"
		password "123456789"
		password_confirmation "123456789"
		role "1"
	end
	factory :user2 ,:class =>:User do
		name "123ds"
		email "mnbv@qq.com"
		password "987654321"
		password_confirmation "987654321"
		role "1"
	end

	factory :request do
		content "teacher request"
		association :receiver, :class => :User
		association :sender, :class => :User
		kind "1"
	end
end
=======
# -*- encoding : utf-8 -*-
FactoryGirl.define do
  
  factory :user do
    name "example_user"
    email "example_email@qq.com"
    password "example_password"
    password_confirmation "example_password"
    role 1
    teacher_visible true
    student_visible true
  end

	
end
		
>>>>>>> 有关联的两个模型测不出来，急死了
