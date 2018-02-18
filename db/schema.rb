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

ActiveRecord::Schema.define(version: 20180218171762) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "assets", force: :cascade do |t|
    t.string "parent_obj_type"
    t.bigint "parent_obj_id"
    t.bigint "user_id"
    t.string "title"
    t.string "description"
    t.text "content"
    t.string "type"
    t.string "sub_type"
    t.string "use"
    t.string "asset_type", default: "image"
    t.string "origin_name"
    t.string "origin_identifier"
    t.text "origin_url"
    t.text "upload"
    t.integer "height"
    t.integer "width"
    t.integer "duration"
    t.integer "status", default: 1
    t.integer "availability", default: 1
    t.string "tags", default: [], array: true
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_obj_id", "parent_obj_type", "asset_type", "use"], name: "swell_media_asset_use_index"
    t.index ["parent_obj_type", "parent_obj_id"], name: "index_assets_on_parent_obj_type_and_parent_obj_id"
    t.index ["tags"], name: "index_assets_on_tags", using: :gin
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "parent_id"
    t.string "name"
    t.string "type"
    t.integer "lft"
    t.integer "rgt"
    t.text "description"
    t.string "avatar"
    t.string "cover_image"
    t.integer "status", default: 1
    t.integer "availability", default: 1
    t.integer "seq"
    t.string "slug"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lft"], name: "index_categories_on_lft"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["rgt"], name: "index_categories_on_rgt"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
    t.index ["type"], name: "index_categories_on_type"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "subject"
    t.text "message"
    t.string "type"
    t.string "ip"
    t.string "sub_type"
    t.string "http_referrer"
    t.integer "status", default: 1
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "type"], name: "index_contacts_on_email_and_type"
  end

  create_table "emails", force: :cascade do |t|
    t.string "address"
    t.integer "status", default: 0
    t.string "first_name"
    t.string "last_name"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address", "status"], name: "index_emails_on_address_and_status"
    t.index ["address"], name: "index_emails_on_address", unique: true
    t.index ["status"], name: "index_emails_on_status"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "media", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "managed_by_id"
    t.string "public_id"
    t.bigint "category_id"
    t.bigint "avatar_asset_id"
    t.bigint "working_media_version_id"
    t.bigint "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.string "type"
    t.string "sub_type"
    t.string "title"
    t.string "subtitle"
    t.text "avatar"
    t.string "cover_image"
    t.string "avatar_caption"
    t.string "layout"
    t.string "template"
    t.text "description"
    t.text "content"
    t.string "slug"
    t.string "redirect_url"
    t.boolean "is_commentable", default: true
    t.boolean "is_sticky", default: false
    t.boolean "show_title", default: true
    t.datetime "modified_at"
    t.text "keywords", default: [], array: true
    t.string "duration"
    t.integer "cached_char_count", default: 0
    t.integer "cached_word_count", default: 0
    t.integer "status", default: 1
    t.integer "availability", default: 1
    t.datetime "publish_at"
    t.hstore "properties", default: {}
    t.string "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avatar_asset_id"], name: "index_media_on_avatar_asset_id"
    t.index ["category_id"], name: "index_media_on_category_id"
    t.index ["managed_by_id"], name: "index_media_on_managed_by_id"
    t.index ["parent_id"], name: "index_media_on_parent_id"
    t.index ["public_id"], name: "index_media_on_public_id"
    t.index ["slug", "type"], name: "index_media_on_slug_and_type"
    t.index ["slug"], name: "index_media_on_slug", unique: true
    t.index ["status", "availability"], name: "index_media_on_status_and_availability"
    t.index ["tags"], name: "index_media_on_tags", using: :gin
    t.index ["user_id"], name: "index_media_on_user_id"
    t.index ["working_media_version_id"], name: "index_media_on_working_media_version_id"
  end

  create_table "media_versions", force: :cascade do |t|
    t.bigint "media_id"
    t.bigint "user_id"
    t.integer "status", default: 1
    t.json "versioned_attributes", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_id", "status", "id"], name: "index_media_versions_on_media_id_and_status_and_id"
    t.index ["media_id"], name: "index_media_versions_on_media_id"
    t.index ["user_id"], name: "index_media_versions_on_user_id"
  end

  create_table "oauth_credentials", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "refresh_token"
    t.string "secret"
    t.datetime "expires_at"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider"], name: "index_oauth_credentials_on_provider"
    t.index ["secret"], name: "index_oauth_credentials_on_secret"
    t.index ["token"], name: "index_oauth_credentials_on_token"
    t.index ["uid"], name: "index_oauth_credentials_on_uid"
    t.index ["user_id"], name: "index_oauth_credentials_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "slug"
    t.string "first_name"
    t.string "last_name"
    t.string "avatar"
    t.string "cover_image"
    t.datetime "dob"
    t.string "gender"
    t.string "location"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.integer "status", default: 1
    t.integer "role", default: 1
    t.integer "level", default: 1
    t.string "website_url"
    t.text "bio"
    t.string "short_bio"
    t.text "sig"
    t.string "ip"
    t.float "latitude"
    t.float "longitude"
    t.string "timezone", default: "Pacific Time (US & Canada)"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "password_hint"
    t.string "password_hint_response"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.hstore "properties", default: {}
    t.hstore "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
