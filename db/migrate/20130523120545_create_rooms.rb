# -*- encoding : utf-8 -*-
class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :outline
      t.integer :user_id
      t.timestamps
    end
    add_index :rooms, :user_id
    change_column :rooms, :user_id, :integer, null:false
  end
end
