# == Schema Information
#
# Table name: advertisements
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content    :string(255)      not null
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Advertisement do 
 
  let(:user) { FactoryGirl.create(:user) } 
  
  before { @advertisement = user.advertisements.build(content: "example",role: user.role )}

  subject { @advertisement }

  it { should respond_to(:content) }
  it { should respond_to(:role) }
  it { should respond_to(:user_id) }
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @advertisement.user_id = nil }
    it { should_not be_valid }
  end
  
end
