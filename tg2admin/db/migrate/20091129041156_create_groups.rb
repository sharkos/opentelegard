class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :groupname
      t.text :notes
      t.boolean :allowlogin
      t.boolean :readmail
      t.boolean :sendmail
      t.boolean :readpost
      t.boolean :writepost
      t.boolean :pagesysop
      t.boolean :chat
      t.boolean :download
      t.boolean :upload
      t.boolean :extprogs
      t.boolean :admin_all
      t.boolean :admin_files
      t.boolean :admin_posts
      t.boolean :admin_chat
      t.boolean :admin_extprogs
      t.boolean :admin_mail
      t.boolean :fileareas
      t.boolean :msgareas
      t.integer :dailytimelimit
      t.integer :maxtimedeposit
      t.integer :maxtimewithdraw
      t.integer :maxcredits
      t.integer :maxdownloads
      t.integer :maxdownloadsmb
      t.integer :maxuploads
      t.integer :maxuploadsmb
      t.integer :mailquota
      t.integer :maxbulklists
      t.integer :maxposts

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
