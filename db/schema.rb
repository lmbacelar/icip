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

ActiveRecord::Schema.define(:version => 20111112122208) do

  create_table "aircrafts", :force => true do |t|
    t.string   "registration", :limit => 10
    t.string   "manufacturer", :limit => 50
    t.string   "model",        :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkpoints", :force => true do |t|
    t.string   "number"
    t.integer  "checkpointable_id"
    t.string   "checkpointable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "part_id"
    t.string   "description"
  end

  create_table "closings", :force => true do |t|
    t.string   "support_doc"
    t.string   "comments"
    t.string   "responsible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "image_assignments", :force => true do |t|
    t.integer  "image_id"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "checksum"
  end

  create_table "inspections", :force => true do |t|
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "kind"
    t.integer  "zone_id"
    t.integer  "part_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "konfigurations", :force => true do |t|
    t.integer  "number"
    t.string   "description"
    t.integer  "aircraft_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.integer  "x1"
    t.integer  "y1"
    t.integer  "x2"
    t.integer  "y2"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", :force => true do |t|
    t.string   "number"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "protocols", :force => true do |t|
    t.integer  "revnum"
    t.string   "author"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "part_id"
  end

  create_table "tasks", :force => true do |t|
    t.string   "action"
    t.string   "comment"
    t.string   "technician"
    t.integer  "inspection_id"
    t.integer  "item_id"
    t.integer  "checkpoint_id"
    t.integer  "closing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zones", :force => true do |t|
    t.string   "name",                :limit => 2
    t.string   "description",         :limit => 50
    t.integer  "inspection_interval"
    t.integer  "konfiguration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
