require 'spec_helper'

describe User do 

	before do
		@user = User.new(name: "Demo User", email:"user@demo.com",
			password:"zxcvbnm", password_confirmation:"zxcvbnm")
		@user2 = User.new(name: "Demo User2", email:"user2@demo.com",
			password:"mnbvcxz", password_confirmation:"mnbvcxz")
	end
	
	# subject{@user}

	it{@user.should respond_to(:authenticate)}
	it{@user.should respond_to(:requests)}

	it{@user2.should respond_to(:authenticate)}
	it{@user2.should respond_to(:requests)}

	describe "request associations" do

		before{@user.save}
		before{@user2.save}
		let!(:older_request)do
			FactoryGirl.create(:request, receiver:@user, sender:@user2, created_at: 1.day.ago)
		end
		let!(:newer_request)do
			FactoryGirl.create(:request, receiver:@user, sender:@user2, created_at: 1.hour.ago)
		end

		it "should have the right requests in the right order" do
			@user.requests.should == [older_request, newer_request]
		end
	end

		it "should destroy associated requests" do
			requests = @user.requests.dup
			@user.destroy
			requests.should_not be_empty
			requests.each do |request|
				Request.find_by_id(request.id).should be_nil
			end
		end

end