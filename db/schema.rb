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

ActiveRecord::Schema.define(version: 13) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "content_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "state"
    t.uuid "content_type_id", null: false
    t.uuid "tenant_id", null: false
    t.uuid "creator_id", null: false
    t.uuid "updated_by_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_type_id"], name: "index_content_items_on_content_type_id"
    t.index ["creator_id"], name: "index_content_items_on_creator_id"
    t.index ["deleted_at"], name: "index_content_items_on_deleted_at"
    t.index ["state"], name: "index_content_items_on_state"
    t.index ["tenant_id"], name: "index_content_items_on_tenant_id"
    t.index ["updated_by_id"], name: "index_content_items_on_updated_by_id"
  end

  create_table "content_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.uuid "creator_id", null: false
    t.uuid "tenant_id", null: false
    t.uuid "contract_id", null: false
    t.boolean "publishable", default: false, null: false
    t.string "icon", default: "help"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_content_types_on_contract_id"
    t.index ["creator_id"], name: "index_content_types_on_creator_id"
    t.index ["deleted_at"], name: "index_content_types_on_deleted_at"
    t.index ["name"], name: "index_content_types_on_name"
    t.index ["tenant_id"], name: "index_content_types_on_tenant_id"
  end

  create_table "contentable_decorators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "decorator_id"
    t.string "contentable_type"
    t.uuid "contentable_id"
    t.uuid "tenant_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contentable_type", "contentable_id"], name: "index_contentable_decorators_on_contentable"
    t.index ["decorator_id"], name: "index_contentable_decorators_on_decorator_id"
    t.index ["deleted_at"], name: "index_contentable_decorators_on_deleted_at"
    t.index ["tenant_id"], name: "index_contentable_decorators_on_tenant_id"
  end

  create_table "contracts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "tenant_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_contracts_on_deleted_at"
    t.index ["name"], name: "index_contracts_on_name"
    t.index ["tenant_id"], name: "index_contracts_on_tenant_id"
  end

  create_table "decorators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "data", default: {}, null: false
    t.uuid "tenant_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_decorators_on_deleted_at"
    t.index ["name"], name: "index_decorators_on_name"
    t.index ["tenant_id"], name: "index_decorators_on_tenant_id"
  end

  create_table "field_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", default: {}, null: false
    t.uuid "field_id", null: false
    t.uuid "content_item_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_item_id"], name: "index_field_items_on_content_item_id"
    t.index ["data"], name: "index_field_items_on_data", using: :gin
    t.index ["deleted_at"], name: "index_field_items_on_deleted_at"
    t.index ["field_id"], name: "index_field_items_on_field_id"
  end

  create_table "field_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
  end

  create_table "fields", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "field_type", null: false
    t.jsonb "metadata", default: {}, null: false
    t.jsonb "validations", default: {}, null: false
    t.uuid "content_type_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_type_id"], name: "index_fields_on_content_type_id"
    t.index ["deleted_at"], name: "index_fields_on_deleted_at"
    t.index ["field_type"], name: "index_fields_on_field_type"
    t.index ["name"], name: "index_fields_on_name"
  end

  create_table "flipper_features", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key"], name: "index_flipper_gates_on_feature_key", unique: true
    t.index ["key"], name: "index_flipper_gates_on_key", unique: true
    t.index ["value"], name: "index_flipper_gates_on_value", unique: true
  end

  create_table "permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.uuid "resource_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_permissions_on_deleted_at"
    t.index ["name"], name: "index_permissions_on_name"
    t.index ["resource_id"], name: "index_permissions_on_resource_id"
    t.index ["resource_type"], name: "index_permissions_on_resource_type"
  end

  create_table "permissions_roles", id: false, force: :cascade do |t|
    t.uuid "permission_id", null: false
    t.uuid "role_id", null: false
    t.index ["permission_id"], name: "index_permissions_roles_on_permission_id"
    t.index ["role_id"], name: "index_permissions_roles_on_role_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.uuid "resource_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.uuid "role_id", null: false
    t.uuid "user_id", null: false
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "tenants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description"
    t.uuid "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.datetime "deleted_at"
    t.datetime "active_at"
    t.datetime "deactive_at"
    t.uuid "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_tenants_on_deleted_at"
    t.index ["name"], name: "index_tenants_on_name", unique: true
    t.index ["owner_id"], name: "index_tenants_on_owner_id"
    t.index ["parent_id"], name: "index_tenants_on_parent_id"
  end

  create_table "tenants_users", id: false, force: :cascade do |t|
    t.uuid "tenant_id", null: false
    t.uuid "user_id", null: false
    t.index ["tenant_id"], name: "index_tenants_users_on_tenant_id"
    t.index ["user_id"], name: "index_tenants_users_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "locale", limit: 30, default: "en_US", null: false
    t.string "timezone", limit: 30, default: "EST", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_tenant_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["active_tenant_id"], name: "index_users_on_active_tenant_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "content_items", "content_types"
  add_foreign_key "content_items", "tenants"
  add_foreign_key "content_items", "users", column: "creator_id"
  add_foreign_key "content_items", "users", column: "updated_by_id"
  add_foreign_key "content_types", "contracts"
  add_foreign_key "content_types", "tenants"
  add_foreign_key "content_types", "users", column: "creator_id"
  add_foreign_key "contentable_decorators", "decorators"
  add_foreign_key "contentable_decorators", "tenants"
  add_foreign_key "contracts", "tenants"
  add_foreign_key "decorators", "tenants"
  add_foreign_key "field_items", "content_items"
  add_foreign_key "field_items", "fields"
  add_foreign_key "fields", "content_types"
  add_foreign_key "permissions_roles", "permissions"
  add_foreign_key "permissions_roles", "roles"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "tenants", "users", column: "owner_id"
  add_foreign_key "tenants_users", "tenants"
  add_foreign_key "tenants_users", "users"
  add_foreign_key "users", "tenants", column: "active_tenant_id"
end
