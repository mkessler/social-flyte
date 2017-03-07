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

ActiveRecord::Schema.define(version: 20170307061459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.integer  "network_id",          null: false
    t.integer  "user_id",             null: false
    t.string   "network_user_id",     null: false
    t.string   "encrypted_token",     null: false
    t.string   "encrypted_secret"
    t.datetime "expires_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "encrypted_token_iv",  null: false
    t.string   "encrypted_secret_iv"
    t.index ["network_id"], name: "index_access_tokens_on_network_id", using: :btree
    t.index ["user_id", "network_id"], name: "index_access_tokens_on_user_id_and_network_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_access_tokens_on_user_id", using: :btree
  end

  create_table "campaigns", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.string   "name",            null: false
    t.string   "slug",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id", "name"], name: "index_campaigns_on_organization_id_and_name", unique: true, using: :btree
    t.index ["organization_id", "slug"], name: "index_campaigns_on_organization_id_and_slug", unique: true, using: :btree
    t.index ["organization_id"], name: "index_campaigns_on_organization_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id",                            null: false
    t.string   "network_comment_id",                 null: false
    t.string   "network_user_id",                    null: false
    t.string   "network_user_name",                  null: false
    t.string   "attachment_image"
    t.string   "attachment_url"
    t.integer  "like_count",         default: 0,     null: false
    t.text     "message",                            null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "posted_at",                          null: false
    t.boolean  "flagged",            default: false, null: false
    t.index ["post_id", "network_comment_id"], name: "index_comments_on_post_id_and_network_comment_id", unique: true, using: :btree
    t.index ["post_id"], name: "index_comments_on_post_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "organization_id",                 null: false
    t.integer  "sender_id",                       null: false
    t.integer  "recipient_id"
    t.string   "email",                           null: false
    t.string   "token",                           null: false
    t.boolean  "accepted",        default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["organization_id", "email"], name: "index_invitations_on_organization_id_and_email", unique: true, using: :btree
    t.index ["organization_id"], name: "index_invitations_on_organization_id", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id", "user_id"], name: "index_memberships_on_organization_id_and_user_id", unique: true, using: :btree
    t.index ["organization_id"], name: "index_memberships_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "networks", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_networks_on_slug", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "network_id",                     null: false
    t.string   "network_post_id",                null: false
    t.string   "network_parent_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "campaign_id",                    null: false
    t.integer  "sync_count",         default: 0, null: false
    t.datetime "synced_at"
    t.string   "job_id"
    t.integer  "twitter_account_id"
    t.index ["campaign_id", "network_id", "network_post_id"], name: "index_posts_on_campaign_id_and_network_id_and_network_post_id", unique: true, using: :btree
    t.index ["campaign_id"], name: "index_posts_on_campaign_id", using: :btree
    t.index ["network_id"], name: "index_posts_on_network_id", using: :btree
  end

  create_table "reactions", force: :cascade do |t|
    t.integer  "post_id",                              null: false
    t.string   "network_user_id",                      null: false
    t.string   "network_user_name",                    null: false
    t.string   "network_user_picture",                 null: false
    t.string   "category",                             null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "flagged",              default: false, null: false
    t.index ["category"], name: "index_reactions_on_category", using: :btree
    t.index ["post_id", "network_user_id"], name: "index_reactions_on_post_id_and_network_user_id", unique: true, using: :btree
    t.index ["post_id"], name: "index_reactions_on_post_id", using: :btree
  end

  create_table "tweets", force: :cascade do |t|
    t.integer  "post_id",                                  null: false
    t.string   "network_tweet_id",                         null: false
    t.string   "network_user_id",                          null: false
    t.string   "network_user_name",                        null: false
    t.integer  "favorite_count",           default: 0,     null: false
    t.integer  "retweet_count",            default: 0,     null: false
    t.text     "message",                                  null: false
    t.text     "hashtags"
    t.datetime "posted_at",                                null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "flagged",                  default: false, null: false
    t.string   "network_user_screen_name",                 null: false
    t.index ["post_id", "network_tweet_id"], name: "index_tweets_on_post_id_and_network_tweet_id", unique: true, using: :btree
    t.index ["post_id"], name: "index_tweets_on_post_id", using: :btree
  end

  create_table "twitter_accounts", force: :cascade do |t|
    t.integer  "organization_id",     null: false
    t.string   "twitter_id",          null: false
    t.string   "encrypted_token",     null: false
    t.string   "encrypted_secret",    null: false
    t.string   "encrypted_token_iv",  null: false
    t.string   "encrypted_secret_iv", null: false
    t.string   "screen_name",         null: false
    t.string   "image_url",           null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["organization_id", "twitter_id"], name: "index_twitter_accounts_on_organization_id_and_twitter_id", unique: true, using: :btree
    t.index ["organization_id"], name: "index_twitter_accounts_on_organization_id", using: :btree
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
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "name",                                null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "access_tokens", "networks"
  add_foreign_key "access_tokens", "users"
  add_foreign_key "campaigns", "organizations"
  add_foreign_key "comments", "posts"
  add_foreign_key "invitations", "organizations"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "posts", "campaigns"
  add_foreign_key "posts", "networks"
  add_foreign_key "reactions", "posts"
  add_foreign_key "tweets", "posts"
  add_foreign_key "twitter_accounts", "organizations"
end
