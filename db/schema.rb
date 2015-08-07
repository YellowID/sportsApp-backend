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

ActiveRecord::Schema.define(version: 20150807102437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "access_token"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", using: :btree

  create_table "game_members", force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.string  "state"
  end

  add_index "game_members", ["game_id", "user_id"], name: "index_game_members_on_game_id_and_user_id", unique: true, using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sport_type_id"
    t.datetime "start_at"
    t.integer  "age"
    t.integer  "numbers"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "country"
    t.string   "city"
    t.string   "address"
    t.decimal  "latitude",      precision: 15, scale: 10
    t.decimal  "longitude",     precision: 15, scale: 10
  end

  add_index "games", ["sport_type_id"], name: "index_games_on_sport_type_id", using: :btree
  add_index "games", ["user_id"], name: "index_games_on_user_id", using: :btree

  create_table "sport_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "user_sport_type_settings", force: :cascade do |t|
    t.integer "sport_type_id"
    t.integer "user_id"
    t.integer "level",         default: 1
  end

  add_index "user_sport_type_settings", ["sport_type_id", "user_id"], name: "index_user_sport_type_settings_on_sport_type_id_and_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "name"
    t.string  "email"
    t.string  "provider"
    t.string  "oauth_token"
    t.string  "chat_password"
    t.integer "age"
    t.string  "token"
    t.string  "avatar"
    t.integer "level"
    t.string  "provider_id"
  end

  add_index "users", ["provider", "oauth_token"], name: "index_users_on_provider_and_oauth_token", unique: true, using: :btree

end
