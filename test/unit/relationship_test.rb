# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: relationships
#
#  id              :integer          not null, primary key
#  student_id      :integer          not null
#  teacher_id      :integer          not null
#  evaluation      :string(255)
#  is_active       :boolean          default(TRUE), not null
#  evaluation_time :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
