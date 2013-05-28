# -*- encoding : utf-8 -*-
class CreateStudentRelationships < ActiveRecord::Migration
  def change
    create_table :student_relationships do |t|
      t.integer :user_id, null: false
      t.integer :subject_id, null: false
    end
    add_index :student_relationships, [:user_id, :subject_id], unique: true
  end
end
