class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :student_id
      t.integer :teacher_id
      t.string :evaluation
      t.boolean :is_active
      t.datetime :evaluation_time

      t.timestamps
    end

    add_index :relationships, :student_id
    add_index :relationships, :teacher_id
    add_index :relationships, [:student_id,:teacher_id], unique:true
    
    change_column :relationships, :student_id, :integer, null: false
    change_column :relationships, :teacher_id, :integer, null: false
    change_column :relationships, :is_active, :boolean, null: false, default: true

    
  end
end
