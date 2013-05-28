# -*- encoding : utf-8 -*-
class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name, null: false, unique: true
    end
  end
end
