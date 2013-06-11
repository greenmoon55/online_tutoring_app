# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  sender_id   :integer          not null
#  receiver_id :integer          not null
#  content     :string(255)
#  created_at  :datetime         not null
#  read        :boolean          default(FALSE)
#

# -*- encoding : utf-8 -*-
require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
