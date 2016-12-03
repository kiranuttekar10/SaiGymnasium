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

ActiveRecord::Schema.define(version: 20161117092309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fee_details", force: :cascade do |t|
    t.integer  "member_id"
    t.date     "fee_date"
    t.integer  "fee_amount"
    t.integer  "pending_fee"
    t.integer  "fee_paid"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.date     "admission_date"
    t.date     "last_fee_date"
    t.date     "next_fee_date"
    t.integer  "status",         default: 0, null: false
    t.integer  "amount",         default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["name"], name: "index_members_on_name", using: :btree
  end

end
