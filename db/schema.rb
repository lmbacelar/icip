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

ActiveRecord::Schema.define(:version => 20111006195646) do

  create_table "aircrafts", :force => true do |t|
    t.string   "registration", :limit => 10
    t.string   "manufacturer", :limit => 50
    t.string   "model",        :limit => 50
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

  create_table "zones", :force => true do |t|
    t.string   "name",                :limit => 2
    t.string   "description",         :limit => 50
    t.integer  "inspection_interval"
    t.integer  "konfiguration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
