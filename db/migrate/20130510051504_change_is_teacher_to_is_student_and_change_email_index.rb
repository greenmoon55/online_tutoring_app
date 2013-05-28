# -*- encoding : utf-8 -*-
class ChangeIsTeacherToIsStudentAndChangeEmailIndex < ActiveRecord::Migration
  def up
    rename_column :users, :is_teacher, :is_student
    remove_index :users, :email
    add_index :users, [:email, :is_student], unique: true
  end

  def down
    remove_index :users, :column => [:email, :is_student]
    add_index :users, :email, unique: true
    rename_column :users, :is_student, :is_teacher
  end
end
