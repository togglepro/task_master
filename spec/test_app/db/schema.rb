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

ActiveRecord::Schema.define(version: 20150811140226) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "managers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_master_custom_requests", force: :cascade do |t|
    t.string   "title"
    t.text     "description",                            null: false
    t.text     "custom_fields",                          null: false
    t.decimal  "bid",                                    null: false
    t.datetime "expiration_date",                        null: false
    t.string   "key"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.text     "responses",              default: "[]"
    t.integer  "numeric_status"
    t.datetime "fancyhands_created_at"
    t.datetime "fancyhands_updated_at"
    t.text     "answers",                default: "{}"
    t.integer  "requestor_id"
    t.string   "requestor_type"
    t.text     "messages",               default: "[]"
    t.text     "phone_calls",            default: "[]"
    t.boolean  "closed_without_answers", default: false
    t.integer  "phone_call_seconds",     default: 0
    t.datetime "fancyhands_closed_at"
  end

  add_index "task_master_custom_requests", ["requestor_id", "requestor_type"], name: "idx_fcr_ri_rt", using: :btree

end
