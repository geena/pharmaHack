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

ActiveRecord::Schema.define(version: 20160325163028) do

  create_table "orders", force: true do |t|
    t.string   "patient_name"
    t.text     "order_name",    limit: 255
    t.string   "status"
    t.text     "dosage",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "image",         limit: 255
    t.text     "instructions"
    t.text     "error_message"
    t.datetime "timestamp"
    t.string   "route"
    t.string   "dob"
    t.text     "frequency"
  end

  add_index "orders", ["status"], name: "index_orders_on_status"

  create_table "patients", force: true do |t|
    t.string   "name"
    t.string   "dob"
    t.text     "allergies",  default: "--- []\n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
