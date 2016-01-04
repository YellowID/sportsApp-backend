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

ActiveRecord::Schema.define(version: 20160104173025) do

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
    t.string   "note"
  end

  add_index "games", ["sport_type_id"], name: "index_games_on_sport_type_id", using: :btree
  add_index "games", ["user_id"], name: "index_games_on_user_id", using: :btree

  create_table "rpush_apps", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                        default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                       default: 86400
    t.boolean  "delivered",                    default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                       default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                default: false
    t.string   "type",                                             null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",             default: false,     null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                           null: false
    t.integer  "retries",                      default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                   default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
  end

  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree

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
    t.string  "device_id"
  end

  add_index "users", ["provider", "oauth_token"], name: "index_users_on_provider_and_oauth_token", unique: true, using: :btree

end
