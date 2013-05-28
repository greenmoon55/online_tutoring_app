# -*- encoding : utf-8 -*-
class RenameMyTypeToTypeByHand < ActiveRecord::Migration
  def up
    rename_column :Users, :my_type, :type
  end

  def down
    rename_column :Users, :type, :my_type
  end
end
