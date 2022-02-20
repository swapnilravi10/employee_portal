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

ActiveRecord::Schema.define(version: 2021_09_14_093530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_assignments_on_role_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.string "year"
    t.datetime "date"
    t.boolean "halfday"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bankdetails", force: :cascade do |t|
    t.string "bank_name"
    t.string "account_number"
    t.string "ifsc_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_bankdetails_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "company_name"
    t.string "email"
    t.bigint "phone_number"
    t.string "country"
    t.string "company_email"
    t.string "company_registration_number"
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "designations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "device_types", force: :cascade do |t|
    t.string "device_type"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.integer "device_type_id"
    t.text "description"
    t.integer "assigned_to"
  end

  create_table "empleaves", force: :cascade do |t|
    t.datetime "start_time"
    t.text "description"
    t.boolean "approved"
    t.boolean "half_day"
    t.datetime "approval_date"
    t.bigint "requestee_id", null: false
    t.bigint "attendee_id", null: false
    t.datetime "rejection_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "leave_identifier"
    t.boolean "cancelled", default: false
    t.boolean "notified", default: false
    t.string "half_day_for"
    t.datetime "end_time"
    t.boolean "wfh", default: false
    t.index ["attendee_id"], name: "index_empleaves_on_attendee_id"
    t.index ["requestee_id"], name: "index_empleaves_on_requestee_id"
  end

  create_table "employeeeducations", force: :cascade do |t|
    t.string "highest_education"
    t.string "university"
    t.string "college"
    t.integer "user_id"
    t.integer "year_of_passing"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "holiday", default: false
  end

  create_table "leavecounters", force: :cascade do |t|
    t.decimal "leaves"
    t.string "year"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_leavecounters_on_user_id"
  end

  create_table "payrolls", force: :cascade do |t|
    t.integer "user_id"
    t.integer "vacation_days_taken"
    t.integer "vacation_days_ytd"
    t.integer "leave_without_pay"
    t.float "basic_current_month", default: 0.0
    t.float "basic_to_date", default: 0.0
    t.float "dearness_allowance_current_month", default: 0.0
    t.float "dearness_allowance_to_date", default: 0.0
    t.float "conveyance_allowance_current_month", default: 0.0
    t.float "conveyance_allowance_to_date", default: 0.0
    t.float "house_rent_allowance_current_month", default: 0.0
    t.float "house_rent_allowance_to_date", default: 0.0
    t.float "professional_development_allowance_current_month", default: 0.0
    t.float "professional_development_allowance_to_date", default: 0.0
    t.float "children_education_allowance_current_month", default: 0.0
    t.float "children_education_allowance_to_date", default: 0.0
    t.float "telephone_expense_allowance_current_month", default: 0.0
    t.float "telephone_expense_allowance_to_date", default: 0.0
    t.float "medical_allowance_current_month", default: 0.0
    t.float "medical_allowance_to_date", default: 0.0
    t.float "others_current_month", default: 0.0
    t.float "others_to_date", default: 0.0
    t.float "professional_tax_current_month", default: 0.0
    t.float "professional_tax_to_date", default: 0.0
    t.float "income_tax_current_month", default: 0.0
    t.float "income_tax_to_date", default: 0.0
    t.float "salary_advance_current_month", default: 0.0
    t.float "salary_advance_to_date", default: 0.0
    t.float "other_current_month", default: 0.0
    t.float "other_to_date", default: 0.0
    t.date "month"
    t.float "earning_total_current_month", default: 0.0
    t.float "earning_total_to_date", default: 0.0
    t.float "net_current_pay", default: 0.0
    t.float "deduction_total_current_month", default: 0.0
    t.float "deduction_total_to_date", default: 0.0
  end

  create_table "post_attachments", force: :cascade do |t|
    t.integer "post_id"
    t.string "post_image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "post_likes", force: :cascade do |t|
    t.integer "post_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text "post"
    t.integer "like"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "project_teams", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.string "designation"
    t.string "project_profile"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_project_teams_on_project_id"
    t.index ["user_id"], name: "index_project_teams_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "client_id"
    t.integer "project_leader_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "setups", force: :cascade do |t|
    t.integer "yearly_leaves"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "status"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.boolean "is_team_leader", default: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "project_manager_id"
    t.index ["project_manager_id"], name: "index_teams_on_project_manager_id"
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "otp"
    t.string "email", null: false
    t.string "password_digest"
    t.bigint "phone_number"
    t.boolean "is_admin", default: false
    t.boolean "archived", default: false
    t.datetime "date_of_joining"
    t.datetime "archival_date"
    t.datetime "logged_in_at"
    t.string "adhar_card_number"
    t.string "pan_card_number"
    t.boolean "logged_in", default: false
    t.string "emergency_contact_name"
    t.bigint "emergency_contact_number"
    t.integer "designation_id"
  end

  create_table "userstatuses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "status_id"
  end

  create_table "usertechnologies", force: :cascade do |t|
    t.integer "user_id"
    t.integer "technology_id"
  end

  create_table "workexperiences", force: :cascade do |t|
    t.integer "user_id"
    t.float "duration_of_work"
    t.string "role"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignments", "roles"
  add_foreign_key "assignments", "users"
  add_foreign_key "empleaves", "users", column: "attendee_id"
  add_foreign_key "empleaves", "users", column: "requestee_id"
  add_foreign_key "project_teams", "projects"
  add_foreign_key "project_teams", "users"
end
