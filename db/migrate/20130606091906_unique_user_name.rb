class UniqueUserName < ActiveRecord::Migration
  def up
    add_index :users, :name, unique: true
  end

  def down
    remove_index :users, :column => :name
  end
end
