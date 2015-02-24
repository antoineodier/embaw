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

ActiveRecord::Schema.define(version: 20150224102846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contribution_transcriptions", force: :cascade do |t|
    t.integer  "transcription_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "contribution_transcriptions", ["transcription_id"], name: "index_contribution_transcriptions_on_transcription_id", using: :btree
  add_index "contribution_transcriptions", ["user_id"], name: "index_contribution_transcriptions_on_user_id", using: :btree

  create_table "contribution_translations", force: :cascade do |t|
    t.integer  "translation_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "contribution_translations", ["translation_id"], name: "index_contribution_translations_on_translation_id", using: :btree
  add_index "contribution_translations", ["user_id"], name: "index_contribution_translations_on_user_id", using: :btree

  create_table "scans", force: :cascade do |t|
    t.integer  "transcription_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "scans", ["transcription_id"], name: "index_scans_on_transcription_id", using: :btree

  create_table "transcriptions", force: :cascade do |t|
    t.string   "path_to_xml_file"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "translations", force: :cascade do |t|
    t.string   "path_to_xml_file"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "transcription_id"
  end

  add_index "translations", ["transcription_id"], name: "index_translations_on_transcription_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "contribution_transcriptions", "transcriptions"
  add_foreign_key "contribution_transcriptions", "users"
  add_foreign_key "contribution_translations", "translations"
  add_foreign_key "contribution_translations", "users"
  add_foreign_key "scans", "transcriptions"
  add_foreign_key "translations", "transcriptions"
end
