class RenameTypeToRoleByHand < ActiveRecord::Migration
  def up
    rename_column :Users, :type, :role
  end

  def down
    rename_column :Users, :role, :type
  end
end
