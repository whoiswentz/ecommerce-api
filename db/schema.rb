# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_14_002053) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "coupon_status", ["active", "inactive"]
  create_enum "game_mode", ["pvp", "pve", "both"]
  create_enum "license_platform", ["steam", "battle_net", "origin", "ps5", "xbox"]
  create_enum "license_status", ["used", "available", "canceled", "pending_creation", "pending_cancellation"]
  create_enum "product_status", ["available", "out_of_stock"]
  create_enum "profile", ["admin", "normal"]

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "unique_categories", unique: true
  end

  create_table "coupons", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.enum "coupon_status", default: "inactive", null: false, enum_type: "coupon_status"
    t.decimal "discount_value", precision: 5, scale: 2
    t.integer "max_use"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_coupons_on_code", unique: true
  end

  create_table "games", force: :cascade do |t|
    t.enum "mode", default: "both", null: false, enum_type: "game_mode"
    t.datetime "release_date"
    t.string "developer"
    t.bigint "system_requirement_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_requirement_id"], name: "index_games_on_system_requirement_id"
  end

  create_table "licenses", force: :cascade do |t|
    t.string "key"
    t.enum "license_platform", null: false, enum_type: "license_platform"
    t.enum "license_status", default: "pending_creation", enum_type: "license_status"
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_licenses_on_game_id"
    t.index ["key", "license_platform"], name: "index_licenses_on_key_and_license_platform", unique: true
  end

  create_table "product_categories", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.string "productable_type", null: false
    t.bigint "productable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "product_status", default: "available", null: false, enum_type: "product_status"
    t.boolean "featured", default: false
    t.index ["productable_type", "productable_id"], name: "index_products_on_productable"
  end

  create_table "system_requirements", force: :cascade do |t|
    t.string "name"
    t.string "os"
    t.string "storage"
    t.string "cpu"
    t.string "memory"
    t.string "gpu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "email"
    t.enum "profile", default: "normal", null: false, enum_type: "profile"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "games", "system_requirements"
  add_foreign_key "licenses", "games"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
end
