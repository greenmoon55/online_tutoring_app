# == Schema Information
#
# Table name: requests
#
#  id          :integer          not null, primary key
#  kind        :integer          not null
#  receiver_id :integer          not null
#  sender_id   :integer          not null
#  content     :boolean          default(FALSE), not null
#  read        :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
