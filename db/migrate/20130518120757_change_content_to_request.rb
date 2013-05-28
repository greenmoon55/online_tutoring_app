# -*- encoding : utf-8 -*-
class ChangeContentToRequest < ActiveRecord::Migration
  def up
    change_column :Requests, :content, :string
  end

  def down
    change_column :Requests, :content, :boolean
  end
end
