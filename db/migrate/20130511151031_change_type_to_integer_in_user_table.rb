# -*- encoding : utf-8 -*-
class ChangeTypeToIntegerInUserTable < ActiveRecord::Migration
  def up
    change_column :Users, :my_type, :integer
  end

  def down
    change_column :Users, :my_type, :boolean
  end
end
