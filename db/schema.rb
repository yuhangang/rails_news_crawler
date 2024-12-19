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

ActiveRecord::Schema[8.0].define(version: 2024_12_19_020431) do
  create_table "news_articles", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.text "description"
    t.text "content"
    t.datetime "published_at"
    t.string "source"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "publisher_id", null: false
    t.index ["link"], name: "index_news_articles_on_link", unique: true
    t.index ["published_at"], name: "index_news_articles_on_published_at"
    t.index ["publisher_id"], name: "index_news_articles_on_publisher_id"
    t.index ["source"], name: "index_news_articles_on_source"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "language"
    t.boolean "is_new"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "feed_url"
    t.index ["slug"], name: "index_publishers_on_slug", unique: true
  end

  add_foreign_key "news_articles", "publishers"
end
