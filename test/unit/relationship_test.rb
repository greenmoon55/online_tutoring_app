# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  teacher_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# -*- encoding : utf-8 -*-
require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
