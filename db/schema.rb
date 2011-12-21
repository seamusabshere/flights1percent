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

ActiveRecord::Schema.define(:version => 20111119200443) do

  create_table "aircraft", :id => false, :force => true do |t|
    t.string "tail_number",             :null => false
    t.string "manufacturer_model_code"
  end

  create_table "aircraft_models", :id => false, :force => true do |t|
    t.string "code",              :null => false
    t.string "manufacturer_name"
    t.string "model_name"
  end

  create_table "aircraft_registrations", :id => false, :force => true do |t|
    t.string  "stupid_key",  :null => false
    t.string  "full_name"
    t.string  "tail_number"
    t.integer "seats"
  end

  create_table "flights", :id => false, :force => true do |t|
    t.string "row_hash",            :null => false
    t.text   "raw_wsj_data"
    t.text   "raw_emission_data"
    t.string "tail_number"
    t.float  "carbon_object_value"
  end

  create_table "people", :id => false, :force => true do |t|
    t.string "full_name", :null => false
    t.string "blurb"
  end

end
