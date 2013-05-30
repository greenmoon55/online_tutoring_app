require 'spec_helper'

describe Relationship do

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user2) }
  before 
    {@relationship = Relationship.new(student_id:user.id , teacher_id: user2.id)}

  subject { @relationship }

  it { should respond_to(:student_id) }
  it { should respond_to(:teacher_id) }

  it { should be_valid }

  describe "when teacher_id is not present" do
    before { @relationship.teacher_id = nil }
    it { should_not be_valid }
  end
  describe "when student_id is not present" do
    before { @relationship.student_id = nil }
    it { should_not be_valid }
  end
end
