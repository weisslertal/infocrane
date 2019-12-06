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

ActiveRecord::Schema.define(version: 20191201172147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crane_operations", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "operation_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cranes", force: :cascade do |t|
    t.integer "identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_cranes_on_identifier", unique: true
  end

  create_table "cycles", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "crane_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "load_type_id"
    t.index ["crane_id"], name: "index_cycles_on_crane_id"
    t.index ["load_type_id"], name: "index_cycles_on_load_type_id"
  end

  create_table "load_types", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensor_events", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.decimal "weight"
    t.decimal "altitude"
    t.datetime "occurrence_time"
    t.bigint "crane_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "identifier", null: false
    t.index ["crane_id"], name: "index_sensor_events_on_crane_id"
  end

  create_table "steps", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "cycle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "identifier"
    t.bigint "crane_operation_id"
    t.index ["crane_operation_id"], name: "index_steps_on_crane_operation_id"
    t.index ["cycle_id"], name: "index_steps_on_cycle_id"
  end

end
