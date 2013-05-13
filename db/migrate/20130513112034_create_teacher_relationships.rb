class CreateTeacherRelationships < ActiveRecord::Migration
  def change
    create_table :teacher_relationships do |t|
      t.integer :user_id, null: false
      t.integer :subject_id, null: false
    end
    add_index :teacher_relationships, [:user_id, :subject_id], unique: true
  end
end
