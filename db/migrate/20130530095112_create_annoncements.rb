class CreateAnnoncements < ActiveRecord::Migration
  def change
    create_table :annoncements do |t|
      t.string :title
      t.text :content

      t.timestamps
    end

    change_column :annoncements, :title, :string, null: false
    change_column :annoncements, :content, :text, null: false
    
  end


end
