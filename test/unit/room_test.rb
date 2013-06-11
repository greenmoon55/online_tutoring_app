# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  outline    :string(255)
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
