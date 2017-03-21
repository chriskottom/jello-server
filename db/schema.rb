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

ActiveRecord::Schema.define(version: 20170321090820) do

  create_table "boards", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "title"
    t.boolean  "archived",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["creator_id"], name: "index_boards_on_creator_id"
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "list_id"
    t.integer  "creator_id"
    t.integer  "assignee_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "archived",    default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["assignee_id"], name: "index_cards_on_assignee_id"
    t.index ["creator_id"], name: "index_cards_on_creator_id"
    t.index ["list_id"], name: "index_cards_on_list_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "creator_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_comments_on_card_id"
    t.index ["creator_id"], name: "index_comments_on_creator_id"
  end

  create_table "lists", force: :cascade do |t|
    t.integer  "board_id"
    t.integer  "creator_id"
    t.string   "title"
    t.boolean  "archived",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["board_id"], name: "index_lists_on_board_id"
    t.index ["creator_id"], name: "index_lists_on_creator_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin",           default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

end
