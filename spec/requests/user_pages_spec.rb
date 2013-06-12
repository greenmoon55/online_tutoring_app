# -*- encoding : utf-8 -*-
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
        fill_in "用户名",         with: "Example_User"
        fill_in "Email",        with: "user@example.com"
        fill_in "密码",     with: "yeziyll"
        fill_in "密码确认", with: "yeziyll"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
