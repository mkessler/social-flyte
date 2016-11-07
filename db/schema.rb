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

ActiveRecord::Schema.define(version: 20161107033228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "network_id",      null: false
    t.string   "network_user_id", null: false
    t.string   "token",           null: false
    t.datetime "expires_at",      null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["network_id"], name: "index_authentications_on_network_id", using: :btree
    t.index ["user_id", "network_id"], name: "index_authentications_on_user_id_and_network_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_authentications_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id",            null: false
    t.string   "network_comment_id", null: false
    t.string   "network_user_id",    null: false
    t.string   "network_user_name",  null: false
    t.string   "like_count",         null: false
    t.text     "message",            null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "posted_at",          null: false
    t.index ["post_id", "network_comment_id"], name: "index_comments_on_post_id_and_network_comment_id", unique: true, using: :btree
    t.index ["post_id"], name: "index_comments_on_post_id", using: :btree
  end

  create_table "networks", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_networks_on_slug", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "network_id",        null: false
    t.string   "network_post_id",   null: false
    t.string   "network_parent_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["network_id"], name: "index_posts_on_network_id", using: :btree
  end

  create_table "reactions", force: :cascade do |t|
    t.integer  "post_id",              null: false
    t.string   "network_user_id",      null: false
    t.string   "network_user_link"
    t.string   "network_user_name"
    t.string   "network_user_picture"
    t.string   "category",             null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["category"], name: "index_reactions_on_category", using: :btree
    t.index ["post_id", "network_user_id"], name: "index_reactions_on_post_id_and_network_user_id", unique: true, using: :btree
    t.index ["post_id"], name: "index_reactions_on_post_id", using: :btree
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
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "authentications", "networks"
  add_foreign_key "authentications", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "posts", "networks"
  add_foreign_key "reactions", "posts"
end
