# -*- encoding : utf-8 -*-
class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.integer :user_id
      t.string :content
      t.integer :role

      t.timestamps
    end
    add_index :advertisements, :user_id
    change_column :advertisements, :user_id, :integer, null:false
    change_column :advertisements, :content, :string, null:false
    change_column :advertisements, :role, :integer, null:false
  end
end
