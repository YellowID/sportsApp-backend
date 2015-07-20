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

ActiveRecord::Schema.define(version: 20150720222604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "access_token"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sport_type_id"
    t.datetime "start_at"
    t.integer  "age"
    t.integer  "numbers"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  add_index "users", ["provider", "oauth_token"], name: "index_users_on_provider_and_oauth_token", unique: true, using: :btree

end
