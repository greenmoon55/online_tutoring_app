# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  teacher_id :integer          not null
#  evaluation :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end
