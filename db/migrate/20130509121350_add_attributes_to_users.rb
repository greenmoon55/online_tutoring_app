# -*- encoding : utf-8 -*-
class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_teacher, :boolean
    add_column :users, :gender, :boolean
    add_column :users, :district_id, :integer
    add_column :users, :description, :string
    add_column :users, :visible, :boolean
    add_column :users, :degree_id, :integer
  end
end
