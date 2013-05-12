# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130512085133) do

  create_table "Users", :force => true do |t|
    t.string   "name",                           :null => false
    t.string   "email",                          :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "password_digest",                :null => false
    t.integer  "role",            :default => 1, :null => false
    t.integer  "gender"
    t.integer  "district_id"
    t.string   "description"
    t.boolean  "visible"
    t.integer  "degree_id"
  end

  add_index "Users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "districts", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "subjects", :force => true do |t|
    t.string "name", :null => false
  end

end
