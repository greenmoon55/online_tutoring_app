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

ActiveRecord::Schema.define(:version => 20130516045705) do

  create_table "degrees", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "districts", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "student_id",                        :null => false
    t.integer  "teacher_id",                        :null => false
    t.string   "evaluation"
    t.boolean  "is_active",       :default => true, :null => false
    t.datetime "evaluation_time"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "relationships", ["student_id", "teacher_id"], :name => "index_relationships_on_student_id_and_teacher_id", :unique => true
  add_index "relationships", ["student_id"], :name => "index_relationships_on_student_id"
  add_index "relationships", ["teacher_id"], :name => "index_relationships_on_teacher_id"

  create_table "student_relationships", :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "subject_id", :null => false
  end

  add_index "student_relationships", ["user_id", "subject_id"], :name => "index_student_relationships_on_user_id_and_subject_id", :unique => true

  create_table "subjects", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "teacher_relationships", :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "subject_id", :null => false
  end

  add_index "teacher_relationships", ["user_id", "subject_id"], :name => "index_teacher_relationships_on_user_id_and_subject_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "email",                             :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "password_digest",                   :null => false
    t.integer  "role",            :default => 1,    :null => false
    t.integer  "gender"
    t.integer  "district_id"
    t.string   "description"
    t.integer  "degree_id"
    t.boolean  "teacher_visible", :default => true, :null => false
    t.boolean  "student_visible", :default => true, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
