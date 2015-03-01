# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150224025906) do

  create_table "authors", force: :cascade do |t|
    t.string   "first_name",     limit: 10,  null: false
    t.string   "last_name",      limit: 20,  null: false
    t.string   "preferred_name", limit: 20
    t.string   "nationality",    limit: 15,  null: false
    t.string   "tel",            limit: 24
    t.string   "mobile",         limit: 24
    t.string   "email",          limit: 255
    t.string   "city",           limit: 15
    t.string   "suburb",         limit: 15
    t.string   "street",         limit: 60
    t.integer  "postal_code",    limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "image",          limit: 255
  end

  create_table "authors_books", id: false, force: :cascade do |t|
    t.integer "book_id",   limit: 4
    t.integer "author_id", limit: 4
  end

  add_index "authors_books", ["book_id", "author_id"], name: "index_authors_books_on_book_id_and_author_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.integer  "supplier_id",  limit: 4
    t.integer  "publisher_id", limit: 4
    t.string   "name",         limit: 40
    t.string   "isbn",         limit: 10
    t.string   "image",        limit: 255
    t.float    "price",        limit: 24
    t.integer  "stock",        limit: 4
    t.text     "description",  limit: 65535
    t.integer  "paperback",    limit: 4
    t.string   "language",     limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "books", ["publisher_id"], name: "index_books_on_publisher_id", using: :btree
  add_index "books", ["supplier_id"], name: "index_books_on_supplier_id", using: :btree

  create_table "books_categories", id: false, force: :cascade do |t|
    t.integer "book_id",     limit: 4
    t.integer "category_id", limit: 4
  end

  add_index "books_categories", ["book_id", "category_id"], name: "index_books_categories_on_book_id_and_category_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "image",       limit: 255
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255,                   null: false
    t.text     "description", limit: 65535
    t.boolean  "can_login",   limit: 1,     default: false, null: false
    t.boolean  "can_order",   limit: 1,     default: false, null: false
    t.boolean  "can_admin",   limit: 1,     default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "groups", ["name"], name: "index_groups_on_name", using: :btree

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id",   limit: 4
    t.integer  "book_id",    limit: 4
    t.integer  "quantity",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "order_items", ["order_id", "book_id"], name: "index_order_items_on_order_id_and_book_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "publishers", force: :cascade do |t|
    t.string   "name",          limit: 40,  null: false
    t.string   "contact_name",  limit: 30
    t.string   "contact_title", limit: 30
    t.string   "tel",           limit: 24
    t.string   "email",         limit: 255
    t.string   "city",          limit: 15
    t.string   "suburb",        limit: 15
    t.string   "street",        limit: 60
    t.integer  "postal_code",   limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "name",          limit: 40,  null: false
    t.string   "contact_name",  limit: 30
    t.string   "contact_title", limit: 30
    t.string   "tel",           limit: 24,  null: false
    t.string   "email",         limit: 255, null: false
    t.string   "city",          limit: 15
    t.string   "suburb",        limit: 15
    t.string   "street",        limit: 60
    t.integer  "postal_code",   limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",      limit: 10
    t.string   "last_name",       limit: 20
    t.string   "preferred_name",  limit: 20
    t.string   "email",           limit: 255, null: false
    t.string   "password",        limit: 40
    t.string   "password_digest", limit: 255
    t.string   "hashed_password", limit: 40
    t.string   "city",            limit: 15
    t.string   "suburb",          limit: 15
    t.string   "street",          limit: 60
    t.integer  "postal_code",     limit: 4
    t.string   "tel",             limit: 24
    t.string   "mobile",          limit: 24
    t.integer  "group_id",        limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "avatar",          limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree

end
