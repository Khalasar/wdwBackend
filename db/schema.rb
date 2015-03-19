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

ActiveRecord::Schema.define(version: 20141026111028) do
  create_table 'photo_translations', force: true do |t|
    t.integer  'photo_id'
    t.string   'language'
    t.string   'caption',    default: ''
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'photos', force: true do |t|
    t.integer  'place_id'
    t.string   'file'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string   'name'
  end

  create_table 'place_translations', force: true do |t|
    t.integer  'place_id'
    t.string   'title'
    t.string   'subtitle'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string   'language'
  end

  create_table 'places', force: true do |t|
    t.string   'subtitle'
    t.text     'description'
    t.float    'lat',          limit: 24, null: false
    t.float    'lng',          limit: 24, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string   'german_text'
    t.string   'english_text'
  end

  create_table 'places_routes', id: false, force: true do |t|
    t.integer 'place_id'
    t.integer 'route_id'
  end

  add_index 'places_routes', %w(place_id route_id), name: 'index_places_routes_on_place_id_and_route_id', using: :btree
  add_index 'places_routes', ['route_id'], name: 'index_places_routes_on_route_id', using: :btree

  create_table 'route_translations', force: true do |t|
    t.integer  'route_id'
    t.string   'language'
    t.string   'title'
    t.string   'subtitle'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.text     'description'
    t.string   'country'
    t.string   'region'
    t.string   'city'
    t.string   'route_type'
  end

  create_table 'routes', force: true do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string   'place_order'
  end

  create_table 'waypoints', force: true do |t|
    t.integer  'route_id'
    t.float    'lat',        limit: 24, null: false
    t.float    'lng',        limit: 24, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end
end
