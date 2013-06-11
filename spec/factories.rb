# -*- encoding : utf-8 -*-
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

	factory :request2 ,:class =>:Request do
		content "teacher request"
		association :receiver, :factory => :user
		association :sender, :factory => :user2
		kind "1"
	end
end
