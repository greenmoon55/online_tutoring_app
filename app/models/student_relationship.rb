# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: student_relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  subject_id :integer          not null
#

class StudentRelationship < ActiveRecord::Base
  attr_accessible :subject_id, :user_id

  belongs_to :subject
  belongs_to :user

  validates :subject_id, :user_id, presence: :true
  validates :user_id, :uniqueness => { scope: :subject_id }
end
