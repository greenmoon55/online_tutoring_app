# -*- encoding : utf-8 -*-
class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :type
      t.integer :receiver_id
      t.integer :sender_id
      t.string :content
      t.boolean :read

      t.timestamps

      
      
    end

      add_index :requests, :receiver_id
      add_index :requests, :type

      change_column :requests,:type, :integer, null: false
      change_column :requests,:receiver_id, :integer, null: false
      change_column :requests,:sender_id, :integer, null: false
      change_column :requests,:read, :boolean, null: false,default: false
  end
end
