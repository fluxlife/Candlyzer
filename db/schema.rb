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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130128204217) do

  create_table "candlesticks", :force => true do |t|
    t.float  "upper_shadow_length"
    t.float  "lower_shadow_length"
    t.float  "body_length"
    t.float  "upper_shadow_percent"
    t.float  "lower_shadow_percent"
    t.float  "body_percent"
    t.float  "body_top"
    t.float  "body_bottom"
    t.string   "trend"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "quote_id"
  end

  create_table "exchanges", :force => true do |t|
    t.string   "name"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quotes", :force => true do |t|
    t.float  "open"
    t.float  "high"
    t.float  "low"
    t.float  "close"
    t.datetime "datetime"
    t.float  "volume"
    t.integer  "security_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "securities", :force => true do |t|
    t.integer  "exchange_id"
    t.string   "company_name"
    t.string   "symbol"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
