# -*- encoding : utf-8 -*-
class CreateBlockedRelationships < ActiveRecord::Migration
  def change
    create_table :blocked_relationships do |t|
      t.integer :user_id
      t.integer :blocked_user_id
    end
    add_index :blocked_relationships , :user_id
    add_index :blocked_relationships , :blocked_user_id
    change_column :blocked_relationships , :user_id, :integer, null: false
    change_column :blocked_relationships , :blocked_user_id, :integer, null: false
  end
end
