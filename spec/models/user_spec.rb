# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  email           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)      not null
#  role            :integer          default(1), not null
#  gender          :integer
#  district_id     :integer
#  description     :string(255)
#  degree_id       :integer
#  teacher_visible :boolean          default(TRUE), not null
#  student_visible :boolean          default(TRUE), not null
#  video_url       :string(255)
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do 

  
  #此部分叶琳琳写的
  before { @user = User.new(name: "ExampleUser", email: "user@example1.com", role: 1,
           password: "forever", password_confirmation: "forever" ) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:gender) }
  it { should respond_to(:district_id) }
  it { should respond_to(:description) }
  it { should respond_to(:role) }
  it { should respond_to(:student_visible) }
  it { should respond_to(:teacher_visible) }
  it { should respond_to(:degree_id) }
  it { should respond_to(:student_subject_ids) }
  it { should respond_to(:teacher_subject_ids) }
  it { should respond_to(:authenticate) }
  it { should be_valid }
 
 
  describe "when name is not present" do
    before { @user.name = "" }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @user.name = "h" * 21 }
    it { should_not be_valid }
  end
  
  describe "when name is valid" do 
    before { @user.name = "a" * 20 }
    it { should be_valid}
  end

  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end
  
   describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
  
   describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when password is too short" do
    before { @user.password = "a" * 6 }
    it { should_not be_valid }
  end
  
  describe "when name is valid" do
    before { @user.name = "h" * 7 }
    it { should be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  
   describe "with valid user" do 
     it "should create a user" do
        expect { @user.save }.to change(User, :count).by(1)
      end
   end
   
   describe "find_by_email_and_role" do
     before { @user.save } 
     it { should == User.find_by_email_and_role(@user.email,1)}
   end
  



  
  
#此部分吕梦琪写的

	before do
	  @user2 = User.new(name: "Demo User2", email:"user2@demo.com",
      password:"mnbvcxz", password_confirmation:"mnbvcxz")
  end

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
  

    it "should destroy associated requests" do
      requests = @user.requests.dup
      @user.destroy
      requests.should_not be_empty
      requests.each do |request|
        Request.find_by_id(request.id).should be_nil
      end
    end
  end
end
