require 'spec_helper'

describe Request do

  let(:user) { FactoryGirl.create(:user) }
  subject { user }
  it { should be_valid }
  
  before  {@request = user.requests.build!(kind: 3, sender_id: 4, content: "test")}

  subject { @request }
  it { should be_valid }
  it { should respond_to(:receiver_id) }


  describe "when receiver_id is not present" do
    before { @request.receiver_id = nil }
    it { should_not be_valid }
  end
  describe "when content is not present" do
    before { @request.content = nil }
    it { should be_valid }
  end

end
