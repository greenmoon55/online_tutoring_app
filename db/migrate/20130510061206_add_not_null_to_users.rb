class AddNotNullToUsers < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :password_digest, :string, null: false
    change_column :users, :is_student, :boolean, null: false, default: true
  end
end
