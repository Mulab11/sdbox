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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140613041900) do

  create_table "contact_items", force: true do |t|
    t.string   "address",     null: false
    t.string   "name"
    t.integer  "platform_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "contact_item_id"
    t.datetime "receive_time"
    t.integer  "status"
    t.string   "full_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "platforms", force: true do |t|
    t.string   "kind",       null: false
    t.text     "token"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
  end

  create_table "test_messages", force: true do |t|
    t.string  "source"
    t.string  "target"
    t.text    "full_text"
    t.integer "status"
  end

  create_table "users", force: true do |t|
    t.string   "name",            null: false
    t.string   "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_rank"
  end

end
