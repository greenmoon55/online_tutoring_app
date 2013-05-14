class CreateDegrees < ActiveRecord::Migration
  def change
    create_table :degrees do |t|
      t.string :name
    end
  end
end
