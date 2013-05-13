class AddTeacherVisibleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :teacher_visible, :boolean, null: false, default: true
    add_column :users, :student_visible, :boolean, null: false, default: true
    remove_column :users, :visible, :boolean
  end
end
