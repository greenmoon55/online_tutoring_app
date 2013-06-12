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
   test "test_should_create_user" do
     user = User.new
     user.name = "yeziyll"
     user.email = "yeziyll@qq.com"
     user.password = "yeziyll"
     user.password_confirmation = "yeziyll"
     user.role = 0
     user.gender = 0
     user.description = "i am beautiful"

     assert user.save
   end
end
