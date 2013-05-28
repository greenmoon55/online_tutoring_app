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
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
