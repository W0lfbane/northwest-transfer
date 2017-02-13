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

ActiveRecord::Schema.define(version: 20170206232521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_documents_on_project_id" #, using: :btree
  end

  create_table "group_projects", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_projects_on_group_id" #, using: :btree
    t.index ["project_id"], name: "index_group_projects_on_project_id" #, using: :btree
  end

  create_table "group_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_users_on_group_id" #, using: :btree
    t.index ["user_id"], name: "index_group_users_on_user_id" #, using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "resource_state"
  end

  create_table "project_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id" #, using: :btree
    t.index ["user_id"], name: "index_project_users_on_user_id" #, using: :btree
  end 

  create_table "projects", force: :cascade do |t|
    t.string   "title",                                    null: false
    t.text     "description",                              null: false
    t.text     "address",                                  null: false
    t.text     "city",                                     null: false
    t.text     "state",                                    null: false
    t.text     "postal",                                   null: false
    t.text     "country",                   default: "US", null: false
    t.datetime "start_date",                               null: false
    t.datetime "completion_date"
    t.datetime "estimated_completion_date",                null: false
    t.text     "notes"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "resource_state"
  end

  create_table "resource_fields", force: :cascade do |t|
    t.string   "data_key"
    t.string   "data_value"
    t.string   "fieldable_type"
    t.integer  "fieldable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["fieldable_type", "fieldable_id"], name: "index_resource_fields_on_fieldable_type_and_fieldable_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name" #, using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "notes"
    t.string   "resource_state"
    t.index ["project_id"], name: "index_tasks_on_project_id" #, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true #, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true #, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id" #, using: :btree
  end

  add_foreign_key "documents", "projects"
  add_foreign_key "group_projects", "groups"
  add_foreign_key "group_projects", "projects"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "tasks", "projects"
end
