=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/group.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Group Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== Group Structure
The Users & Group models are designed to work as follows:
*  a User holds only the personal data.
*  a Group holds the permissions & limits.
*  a User can only belong to one group.
*  a User with "ADMIN" rights to Users or Groups cannot view or modify
   entries with greater privilege level (Security).
*  a Group has a "level" field which defines the security level. This
   allows the admin to create "custom" groups with varying levels of
   access. The lower the level value, the higher the access
   (integer >= [1..100]).

=end

# Group Structure
class Group < Sequel::Model(:groups)
  Tgio.printstart " DB Model: groups"
  # => Create association of ONE Group to Many Users
  #one_to_many :users

  if empty?
    # => Create Group: SYSOPS
    create  :name => 'SYSOPS',
            :level => '255',
            :dailytimelimit => 1440,
            :maxtimedeposit => -1,
            :maxcredits => -1,
            :maxdownloads => -1,
            :maxdownloadskb => -1,
            :maxuploads => -1,
            :mailquota => -1,
            :maxbulklists => -1,
            :maxposts => -1,
            :allowlogin => true,
            :readmail => true,
            :sendmail => true,
            :msgsarea => true,
            :readpost => true,
            :writepost => true,
            :pagesysop => true,
            :chat => true,
            :filesarea => true,
            :downloads => true,
            :uploads => true,
            :extprogs => true,
            :admin_system => true,
            :admin_files => true,
            :admin_msgs => true,
            :admin_users => true,
            :admin_groups => true,
            :admin_chat => true,
            :admin_extprogs => true,
            :admin_mail => true,
            :sysopnote => 'This is the default all powerful Group',
            :created => Time.now

    # => Create Group: COSYSOPS
    create  :name => 'COSYSOPS',
            :level => '200',
            :dailytimelimit => 1440,
            :maxtimedeposit => -1,
            :maxcredits => -1,
            :maxdownloads => -1,
            :maxdownloadskb => -1,
            :maxuploads => -1,
            :mailquota => -1,
            :maxbulklists => -1,
            :maxposts => -1,
            :allowlogin => true,
            :readmail => true,
            :sendmail => true,
            :msgsarea => true,
            :readpost => true,
            :writepost => true,
            :pagesysop => true,
            :chat => true,
            :filesarea => true,
            :downloads => true,
            :uploads => true,
            :extprogs => true,
            :admin_system => false,
            :admin_files => true,
            :admin_msgs => true,
            :admin_users => true,
            :admin_groups => false,
            :admin_chat => true,
            :admin_extprogs => true,
            :admin_mail => true,
            :sysopnote => 'This is the default almost all powerful Group',
            :created => Time.now

    # => Create Group: USERS
    create  :name => 'USERS',
            :level => '100',
            :dailytimelimit => 60,
            :maxtimedeposit => 30,
            :maxcredits => 1000,
            :maxdownloads => 10,
            :maxdownloadskb => -1,
            :maxuploads => 3,
            :mailquota => 4096,
            :maxbulklists => 1,
            :maxposts => 10,
            :allowlogin => true,
            :readmail => true,
            :sendmail => true,
            :msgsarea => true,
            :readpost => true,
            :writepost => true,
            :pagesysop => true,
            :chat => true,
            :filesarea => true,
            :downloads => true,
            :uploads => true,
            :extprogs => true,
            :admin_system => false,
            :admin_files => false,
            :admin_msgs => false,
            :admin_users => false,
            :admin_groups => false,
            :admin_chat => false,
            :admin_extprogs => false,
            :admin_mail => false,
            :sysopnote => 'This is the default normal user account',
            :created => Time.now

    # => Create Group: LOCKED
    create  :name => 'LOCKED',
            :level => '0',
            :dailytimelimit => 0,
            :maxtimedeposit => 0,
            :maxcredits => 0,
            :maxdownloads => 0,
            :maxdownloadskb => 0,
            :maxuploads => 0,
            :mailquota => 0,
            :maxbulklists => 0,
            :maxposts => 0,
            :allowlogin => false,
            :readmail => false,
            :sendmail => false,
            :msgsarea => false,
            :readpost => false,
            :writepost => false,
            :pagesysop => false,
            :chat => false,
            :filesarea => false,
            :downloads => false,
            :uploads => false,
            :extprogs => false,
            :admin_system => false,
            :admin_files => false,
            :admin_msgs => false,
            :admin_users => false,
            :admin_groups => false,
            :admin_chat => false,
            :admin_extprogs => false,
            :admin_mail => false,
            :sysopnote => 'User with absolutely NO privileges. Locked Out.',
            :created => Time.now

  end
  Tgio.printreturn(0)

  # Test if the group exists in the database
  def self.exists?(groupname)
    group = self[:name=>groupname]
    if group.nil?
      return false
    else
      return true
    end
  end

end #/class Group
