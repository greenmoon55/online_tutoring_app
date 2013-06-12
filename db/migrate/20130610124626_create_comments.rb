class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :student_id
      t.integer :teacher_id
      t.string :evaluation

      t.timestamps
    end
    add_index :comments, :teacher_id
    change_column :comments, :student_id, :integer, null:false
    change_column :comments, :teacher_id, :integer, null:false
    change_column :comments, :evaluation, :integer, null:false
  end
end
