class ChangeTypeToRequest < ActiveRecord::Migration
  def up
    rename_column :Requests, :type, :kind
  end

  def down
    rename_column :Requests, :kind, :type
  end
end
