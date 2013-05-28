# -*- encoding : utf-8 -*-
class AddIndexToUserEmail < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true
  end
end
