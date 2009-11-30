class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :gid
      t.string :username
      t.string :firstname
      t.string :lastname
      t.string :password
      t.date :pwexpires
      t.string :pwhint
      t.text :notes
      t.string :city
      t.string :state
      t.string :postalcode
      t.string :country
      t.string :email
      t.string :gender
      t.string :address1
      t.string :address2
      t.string :phone1
      t.string :phone2
      t.date :bday
      t.timestamp :lastlogin
      t.boolean :enabled
      t.boolean :mailbox
      t.integer :logintotal
      t.integer :timebank
      t.integer :loginfailed
      t.integer :mailquota
      t.integer :totalposts
      t.integer :totaluploads
      t.integer :totaldownloads

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
