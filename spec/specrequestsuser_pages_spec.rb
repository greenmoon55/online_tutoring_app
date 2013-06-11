# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "User pages" do

  subject { page }
  
    describe "signup" do
	before { visit signup_path }
	let(:submit) { "commit" }
	describe "with invalid information" do
        it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
	
	describe "with valid information" do
      before do
        fill_in "user[name]",         with: "example101"
        fill_in "user[email]",        with: "example101@gmail.com"
        fill_in "user[password]",     with: "forever"
	fill_in "user[password_confirmation]", with: "forever"
        #fill_in "user[role]", with: 0
      end
	  
	  it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
