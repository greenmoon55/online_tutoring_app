class RenameMyColumnByHand < ActiveRecord::Migration
  def up
    rename_column :Users, :is_student, :type
  end

  def down
    rename_column :Users, :type, :is_student
  end
end
