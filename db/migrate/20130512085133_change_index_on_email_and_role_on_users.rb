class ChangeIndexOnEmailAndRoleOnUsers < ActiveRecord::Migration
  def up
    remove_index :users, :email_and_is_student
    add_index :users, :email, unique: true
  end

  def down
  end
end
