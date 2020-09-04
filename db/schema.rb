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

ActiveRecord::Schema.define(version: 2020_09_04_165103) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "character_locations", force: :cascade do |t|
    t.string "character"
    t.bigint "scene_id"
    t.integer "x"
    t.integer "y"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scene_id"], name: "index_character_locations_on_scene_id"
  end

  create_table "scenes", force: :cascade do |t|
    t.string "title"
    t.string "asset_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.string "player_name"
    t.integer "time"
    t.bigint "scene_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scene_id"], name: "index_scores_on_scene_id"
  end

  add_foreign_key "character_locations", "scenes"
  add_foreign_key "scores", "scenes"
end
