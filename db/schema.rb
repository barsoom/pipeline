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

ActiveRecord::Schema[7.0].define(version: 2014_02_16_162823) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "builds", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.integer "revision_id"
    t.string "status_url", limit: 255
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", limit: 255, null: false
    t.string "repository", limit: 255
    t.text "mappings"
    t.integer "position", default: 0
  end

  create_table "revisions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "project_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

end
