class ChangeVideoUrlToVideoId < ActiveRecord::Migration
  def change
    rename_column :users, :video_url, :video_id
  end
end
