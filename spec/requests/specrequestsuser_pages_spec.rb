require 'spec_helper'

describe "User pages" do

  subject { page }
  
    describe "signup" do
	before { visit signup_path }
	let(:submit) { "注册" }
	describe "with invalid information" do
        it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
	
	describe "with valid information" do
      before do
        fill_in "用户名",         with: "example101"
        fill_in "Email",        with: "example101@gmail.com"
        fill_in "密码",     with: "forever"
	fill_in "密码确认", with: "forever"
        fill_in "Role", 		with: 0
      end
	  
	  it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
