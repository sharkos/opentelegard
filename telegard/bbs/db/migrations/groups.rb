
Sequel.migration do
  change do
    create_table(:groups) do
      primary_key  :id
      varchar      :name
      varchar      :sysopnote
      TimeStamp    :created
      integer      :level
      integer      :dailytimelimit
      integer      :maxtimedeposit
      integer      :maxtimewithdraw
      integer      :maxcredits
      integer      :maxdownloads
      integer      :maxdownloadskb
      integer      :maxuploads
      integer      :mailquota
      integer      :maxbulklists
      integer      :maxposts
      boolean      :allowlogin
      boolean      :readmail
      boolean      :sendmail
      boolean      :msgsarea
      boolean      :readpost
      boolean      :writepost
      boolean      :pagesysop
      boolean      :chat
      boolean      :filesarea
      boolean      :downloads
      boolean      :uploads
      boolean      :extprogs
      boolean      :admin_system
      boolean      :admin_files
      boolean      :admin_msgs
      boolean      :admin_users
      boolean      :admin_groups
      boolean      :admin_chat
      boolean      :admin_extprogs
      boolean      :admin_mail
    end
  end
end
