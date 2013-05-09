class ChangeGenderTypeToUsers < ActiveRecord::Migration
  def up
    change_column :users, :gender, :integer
  end

  def down
    change_column :users, :gender, :boolean
  end
end
