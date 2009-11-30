# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091129041156) do

  create_table "groups", :force => true do |t|
    t.string   "groupname"
    t.text     "notes"
    t.boolean  "allowlogin"
    t.boolean  "readmail"
    t.boolean  "sendmail"
    t.boolean  "readpost"
    t.boolean  "writepost"
    t.boolean  "pagesysop"
    t.boolean  "chat"
    t.boolean  "download"
    t.boolean  "upload"
    t.boolean  "extprogs"
    t.boolean  "admin_all"
    t.boolean  "admin_files"
    t.boolean  "admin_posts"
    t.boolean  "admin_chat"
    t.boolean  "admin_extprogs"
    t.boolean  "admin_mail"
    t.boolean  "fileareas"
    t.boolean  "msgareas"
    t.integer  "dailytimelimit"
    t.integer  "maxtimedeposit"
    t.integer  "maxtimewithdraw"
    t.integer  "maxcredits"
    t.integer  "maxdownloads"
    t.integer  "maxdownloadsmb"
    t.integer  "maxuploads"
    t.integer  "maxuploadsmb"
    t.integer  "mailquota"
    t.integer  "maxbulklists"
    t.integer  "maxposts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "gid"
    t.string   "username"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "password"
    t.date     "pwexpires"
    t.string   "pwhint"
    t.text     "notes"
    t.string   "city"
    t.string   "state"
    t.string   "postalcode"
    t.string   "country"
    t.string   "email"
    t.string   "gender"
    t.string   "address1"
    t.string   "address2"
    t.string   "phone1"
    t.string   "phone2"
    t.date     "bday"
    t.datetime "lastlogin"
    t.boolean  "enabled"
    t.boolean  "mailbox"
    t.integer  "logintotal"
    t.integer  "timebank"
    t.integer  "loginfailed"
    t.integer  "mailquota"
    t.integer  "totalposts"
    t.integer  "totaluploads"
    t.integer  "totaldownloads"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
