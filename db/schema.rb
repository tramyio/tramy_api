# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_26_040324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id"
    t.integer "role"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_accounts_on_organization_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.jsonb "chat_data"
    t.bigint "lead_id", null: false
    t.bigint "account_id"
    t.boolean "whatsapp_window"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_chats_on_account_id"
    t.index ["lead_id"], name: "index_chats_on_lead_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.bigint "stage_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id"], name: "index_leads_on_organization_id"
    t.index ["phone", "organization_id"], name: "index_leads_on_phone_and_organization_id", unique: true
    t.index ["stage_id"], name: "index_leads_on_stage_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.bigint "chat_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id"], name: "index_notes_on_chat_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "address"
    t.string "domain"
    t.string "provider_api_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pipelines", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_pipelines_on_organization_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "photo_url"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string "name"
    t.bigint "pipeline_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pipeline_id"], name: "index_stages_on_pipeline_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "organizations"
  add_foreign_key "accounts", "users"
  add_foreign_key "chats", "accounts"
  add_foreign_key "chats", "leads"
  add_foreign_key "leads", "organizations"
  add_foreign_key "leads", "stages"
  add_foreign_key "notes", "chats"
  add_foreign_key "pipelines", "organizations"
  add_foreign_key "profiles", "users"
  add_foreign_key "stages", "pipelines"
end
