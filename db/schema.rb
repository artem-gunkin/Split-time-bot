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

ActiveRecord::Schema.define(version: 20160715211901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "breaks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "minutes",    default: 0
    t.integer  "min_left",   default: 0
    t.string   "message_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "result",     default: "active"
    t.index ["user_id"], name: "index_breaks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "telegram_id"
    t.integer  "work_time",       default: 25
    t.integer  "break_time",      default: 5
    t.integer  "long_break_time", default: 15
    t.integer  "state",           default: 0
    t.integer  "state_step",      default: 0
    t.string   "locale",          default: "en"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "little_work",     default: 5
    t.integer  "normal_work",     default: 15
    t.integer  "big_work",        default: 25
    t.integer  "sprint_parts",    default: 4
    t.string   "timezone",        default: "Europe/Moscow"
  end

  create_table "works", force: :cascade do |t|
    t.integer  "minutes",    default: 0
    t.string   "status"
    t.boolean  "sprint",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id"
    t.integer  "min_left",   default: 0
    t.string   "task_type",  default: "task"
    t.integer  "part",       default: 1
    t.integer  "message_id"
    t.index ["user_id"], name: "index_works_on_user_id", using: :btree
  end

end
