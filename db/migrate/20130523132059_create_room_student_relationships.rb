# -*- encoding : utf-8 -*-
class CreateRoomStudentRelationships < ActiveRecord::Migration
  def change
    create_table :room_student_relationships do |t|
      t.integer :student_id
      t.integer :room_id

      t.timestamps
    end
    add_index :room_student_relationships, :student_id
    add_index :room_student_relationships, :room_id
    change_column :room_student_relationships, :student_id, :integer, null:false
    change_column :room_student_relationships, :room_id, :integer, null:false

  end
end
