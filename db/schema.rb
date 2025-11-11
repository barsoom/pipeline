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

ActiveRecord::Schema[8.1].define(version: 2025_11_11_150547) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "builds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "revision_id"
    t.string "status", null: false
    t.string "status_url"
    t.datetime "updated_at", null: false
    t.index ["revision_id", "name", "id"], name: "idx_builds_revision_name_id"
    t.index ["revision_id"], name: "idx_builds_revision_id"
  end

  create_table "cloud_inits", force: :cascade do |t|
    t.jsonb "config", default: {}, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "password_salt", null: false
    t.text "template", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "mappings"
    t.string "name", null: false
    t.integer "position", default: 0
    t.string "repository"
    t.datetime "updated_at", null: false
  end

  create_table "revisions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "created_at"], name: "idx_revisions_project_created_at", order: { created_at: :desc }
    t.index ["project_id", "id"], name: "idx_revisions_project_id_id"
    t.index ["project_id", "name", "id"], name: "idx_revisions_project_name_id"
  end

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.json "object"
    t.json "object_changes"
    t.string "whodunnit"
    t.index ["item_id", "item_type", "created_at", "id"], name: "idx_versions_item_type_created_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end
end
