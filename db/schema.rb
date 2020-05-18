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

ActiveRecord::Schema.define(version: 2020_05_18_140846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commits", force: :cascade do |t|
    t.bigint "git_update_id", null: false
    t.bigint "repository_id", null: false
    t.bigint "release_id", null: false
    t.bigint "committer_id", null: false
    t.bigint "pusher_id", null: false
    t.datetime "pushed_at"
    t.string "pull_request_ids", array: true
    t.string "ticket_ids", array: true
    t.string "sha"
    t.string "message"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["committer_id"], name: "index_commits_on_committer_id"
    t.index ["git_update_id"], name: "index_commits_on_git_update_id"
    t.index ["pusher_id"], name: "index_commits_on_pusher_id"
    t.index ["release_id"], name: "index_commits_on_release_id"
    t.index ["repository_id"], name: "index_commits_on_repository_id"
    t.index ["ticket_ids"], name: "index_commits_on_ticket_ids", using: :gin
  end

  create_table "git_updates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "repository_id", null: false
    t.string "event"
    t.string "external_source"
    t.json "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["repository_id"], name: "index_git_updates_on_repository_id"
    t.index ["user_id"], name: "index_git_updates_on_user_id"
  end

  create_table "pull_requests", force: :cascade do |t|
    t.string "git_update_ids"
    t.bigint "repository_id", null: false
    t.bigint "creator_id", null: false
    t.bigint "approver_id", null: false
    t.bigint "closer_id", null: false
    t.string "external_id"
    t.string "ticket_ids", array: true
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["approver_id"], name: "index_pull_requests_on_approver_id"
    t.index ["closer_id"], name: "index_pull_requests_on_closer_id"
    t.index ["creator_id"], name: "index_pull_requests_on_creator_id"
    t.index ["repository_id"], name: "index_pull_requests_on_repository_id"
    t.index ["ticket_ids"], name: "index_pull_requests_on_ticket_ids", using: :gin
  end

  create_table "releases", force: :cascade do |t|
    t.bigint "git_update_id", null: false
    t.bigint "repository_id", null: false
    t.bigint "releaser_id", null: false
    t.string "ticket_ids", array: true
    t.datetime "released_at"
    t.string "tag_name"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["git_update_id"], name: "index_releases_on_git_update_id"
    t.index ["releaser_id"], name: "index_releases_on_releaser_id"
    t.index ["repository_id"], name: "index_releases_on_repository_id"
    t.index ["ticket_ids"], name: "index_releases_on_ticket_ids", using: :gin
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name"
    t.string "external_id"
    t.string "external_source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "external_id"
    t.string "external_source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "commits", "git_updates"
  add_foreign_key "commits", "releases"
  add_foreign_key "commits", "repositories"
  add_foreign_key "commits", "users", column: "committer_id"
  add_foreign_key "commits", "users", column: "pusher_id"
  add_foreign_key "git_updates", "repositories"
  add_foreign_key "git_updates", "users"
  add_foreign_key "pull_requests", "repositories"
  add_foreign_key "pull_requests", "users", column: "approver_id"
  add_foreign_key "pull_requests", "users", column: "closer_id"
  add_foreign_key "pull_requests", "users", column: "creator_id"
  add_foreign_key "releases", "git_updates"
  add_foreign_key "releases", "repositories"
  add_foreign_key "releases", "users", column: "releaser_id"
end
