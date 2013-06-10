# == Schema Information
#
# Table name: room_student_relationships
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  room_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
require 'test_helper'

class RoomStudentRelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
