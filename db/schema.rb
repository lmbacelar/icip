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

ActiveRecord::Schema.define(:version => 20120111193908) do

  create_table "aircrafts", :force => true do |t|
    t.string   "registration", :limit => 10
    t.string   "manufacturer", :limit => 50
    t.string   "model",        :limit => 50
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "checkpoints", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "part_id"
    t.integer  "protocol_id"
  end

  create_table "closings", :force => true do |t|
    t.string   "support_doc"
    t.string   "comments"
    t.integer  "engineer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "tasc_id"
  end

  create_table "image_assignments", :force => true do |t|
    t.integer  "image_id"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "checksum"
  end

  create_table "inspection_assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "inspection_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "inspections", :force => true do |t|
    t.integer  "zone_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "execution_date"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "zone_id"
    t.integer  "part_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "konfigurations", :force => true do |t|
    t.integer  "number"
    t.string   "description"
    t.integer  "aircraft_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "location_assignments", :force => true do |t|
    t.integer  "location_id"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "locations", :force => true do |t|
    t.integer  "x1",         :default => 0
    t.integer  "y1",         :default => 0
    t.integer  "x2",         :default => 0
    t.integer  "y2",         :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "image_id"
    t.string   "name"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "parts", :force => true do |t|
    t.string   "number"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "kind"
  end

  create_table "protocols", :force => true do |t|
    t.integer  "revnum"
    t.integer  "author_id"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "part_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tascs", :force => true do |t|
    t.string   "action"
    t.string   "etr"
    t.string   "comment"
    t.integer  "technician_id"
    t.integer  "inspection_id"
    t.integer  "item_id"
    t.integer  "checkpoint_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "tap_number"
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "zones", :force => true do |t|
    t.string   "name",                :limit => 2
    t.string   "description",         :limit => 50
    t.integer  "inspection_interval"
    t.integer  "konfiguration_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

end
