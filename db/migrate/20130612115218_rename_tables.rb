class RenameTables < ActiveRecord::Migration
  def change
    rename_table :Requests, :temp
    rename_table :temp, :requests
    rename_table :Comments, :temp
    rename_table :temp, :comments
  end
end
