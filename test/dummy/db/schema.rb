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

ActiveRecord::Schema.define(version: 20150612082804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "suscribir_newsletters", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "suscripciones_count", default: 0
  end

  add_index "suscribir_newsletters", ["suscripciones_count"], name: "index_suscribir_newsletters_on_suscripciones_count", using: :btree

  create_table "suscribir_suscripciones", force: :cascade do |t|
    t.integer  "suscribible_id",                  null: false
    t.string   "suscribible_type",                null: false
    t.string   "dominio_de_alta",  default: "es", null: false
    t.integer  "suscriptor_id"
    t.string   "suscriptor_type"
    t.string   "email",                           null: false
    t.string   "nombre_apellidos"
    t.string   "cod_postal"
    t.integer  "provincia_id"
    t.boolean  "activo",           default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contacto_id"
  end

  add_index "suscribir_suscripciones", ["activo", "suscribible_type", "suscribible_id", "dominio_de_alta"], name: "ix_suscripciones_on_activo_and_suscribible_and_dominio", using: :btree
  add_index "suscribir_suscripciones", ["contacto_id"], name: "index_suscribir_suscripciones_on_contacto_id", using: :btree
  add_index "suscribir_suscripciones", ["email"], name: "index_suscribir_suscripciones_on_email", using: :btree
  add_index "suscribir_suscripciones", ["provincia_id", "activo", "suscribible_type", "suscribible_id", "dominio_de_alta"], name: "ix_suscripciones_on_provincia_activo_suscribible_and_dominio", using: :btree
  add_index "suscribir_suscripciones", ["suscribible_type", "suscribible_id", "dominio_de_alta", "email"], name: "ix_suscripciones_on_suscribible_and_dominio_and_email", unique: true, using: :btree
  add_index "suscribir_suscripciones", ["suscriptor_type", "suscriptor_id", "activo"], name: "ix_suscripciones_on_suscriptor_and_activo", using: :btree

  create_table "tematicas", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "suscripciones_count",             default: 0
  end

  add_index "tematicas", ["suscripciones_count"], name: "index_tematicas_on_suscripciones_count", using: :btree

  create_table "usuarios", force: :cascade do |t|
    t.string   "nombre"
    t.string   "apellidos"
    t.string   "email"
    t.string   "cod_postal"
    t.integer  "provincia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "suscripciones_count", default: 0
  end

  add_index "usuarios", ["suscripciones_count"], name: "index_usuarios_on_suscripciones_count", using: :btree

end
