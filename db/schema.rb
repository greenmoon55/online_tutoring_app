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

ActiveRecord::Schema.define(:version => 20130510081123) do

  create_table "districts", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "email",                             :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "password_digest",                   :null => false
    t.boolean  "is_student",      :default => true, :null => false
    t.integer  "gender"
    t.integer  "district_id"
    t.string   "description"
    t.boolean  "visible"
    t.integer  "degree_id"
  end

  add_index "users", ["email", "is_student"], :name => "index_users_on_email_and_is_student", :unique => true

end