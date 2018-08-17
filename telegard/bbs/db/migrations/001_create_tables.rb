=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2018   LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2008-2018, Chris Tusa & LeafScale Systems, LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions
are met:

    * Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
    * Neither the name of LeafScale Systems nor the names of its contributors
      may be used to endorse or promote products derived from this software 
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.


---[ File Info ]-------------------------------------------------------------

 Source File: bbs/db/migrations/001_create_tables.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Database migration file for creating the table structure.

-----------------------------------------------------------------------------

=end

Sequel.migration do
  change do

#============================================================================
# Table: Users
#============================================================================
    create_table(:users) do
    primary_key  :id
    boolean      :islocked
    String      :login,          :size=>16, :unique=>true
    String      :firstname,      :size=>25
    String      :lastname,       :size=>25
    String      :password
    String      :address1
    String      :address2
    String      :city,           :size=>25
    String      :state,          :size=>5
    String      :postal,         :size=>15
    String      :country,        :size=>5
    String      :phone,          :size=>18
    String      :gender,         :size=>1
    String      :email
    String      :custom1,        :size=>80
    String      :custom2,        :size=>80
    String      :custom3,        :size=>80
    String      :sysopnote,      :text=>true
    String      :pwhint_question
    String      :pwhint_answer
    Date        :bday
    Date        :pwexpires
    Fixnum      :group_id
    Fixnum      :timebank
    Fixnum      :total_files_up
    Fixnum      :total_files_down
    Fixnum      :total_messages
    Fixnum      :login_failures
    Fixnum      :login_total
    TimeStamp   :login_last
    TimeStamp   :created

    # Define Users' Preferences
    boolean     :pref_fastlogin,  :default => false
    Fixnum      :pref_term_height,:default => 24
    Fixnum      :pref_term_width, :default => 80
    boolean     :pref_term_pager, :default => true
    boolean     :pref_term_color, :default => true
    boolean     :pref_show_menus, :default => true
    String      :pref_editor,     :default => 'nano'
    end

#============================================================================
# Table: Groups
#============================================================================
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

#============================================================================
# Table: Sessions
#============================================================================
    create_table(:sessions) do
    # User pointers
    primary_key  :id           # Session ID.
    integer      :user_id      # UID of user
    String       :username     # Alias of User
    integer      :group_id     # Group id for RBAC
    integer      :caller_id    # User's callerid in history
    integer      :level        # Permission Level

    # User Tracking
    integer      :filearea     # ID of user's current filearea
    integer      :msgarea      # ID of user's current msgarea
    integer      :chatroom     # ID of user's current chatroom
    String       :current_area # String defining user's current location
    TimeStamp    :expires      # Time session expires
    TimeStamp    :created      # Time session created

    # User preferences
    boolean      :pref_show_menus # User has menus toggled on/off
    boolean      :pref_term_pager # User has pager toggled on/off
    String       :pref_editor     # User selected editor
    end

#============================================================================
# Table: Callhistory
#============================================================================
    create_table(:callhistory) do
    primary_key  :id
    integer      :user_id
    String       :alias       # Added for convenience.        
    Timestamp    :time_login
    TimeStamp    :time_logout
    end

#============================================================================
# Table: Networks
#============================================================================
    create_table(:networks) do
    primary_key  :id              # Network ID
    String       :name            # Network Logical Name
    text         :description     # Detailed description
    varchar      :protocol            # Type of: 'tgnet', 'fidonet', 'wwiv'  etc...
    boolean      :enabled         # Is enabled?
    TimeStamp    :lastsync        # Timestamp of last sync
    TimeStamp    :created         # Date network added to DB

    # Define TGnet Properties
    String       :tgnet_directory # Directory Server
    String       :tgnet_node      # Node Name    

    # Define FidoNET Properties
    String       :fidonet_node    # Node Address

    # Define WWIVnet Properties
    String       :wwivnet_node    # Node Address
    end

#============================================================================
# Table: Msgareas
#============================================================================
    create_table(:msgareas) do
    primary_key   :id                   # ID
    String        :name                 # Name of Area
    text          :description          # Friendly Description
    boolean       :network              # Is this a network feed?
    integer       :network_id           # Network to use if type = 1
    integer       :minlevel_read        # Minimum Group Level allowed read access
    integer       :minlevel_write       # Minimum Group Level allowed write access
    boolean       :enabled              # Area is enabled
    TimeStamp     :created              # Timestamp
    end

#============================================================================
# Table: Msgs
#============================================================================
    create_table(:msgs) do
    primary_key  :id              # Message ID
    integer      :msgarea_id      # Message Area ID
    integer      :from_id         # ID of sender
    integer      :to_id           # ID of destination if local
    boolean      :read            # ? Message Read or Unread
    boolean      :network         # ? Message is Local or Network
    integer      :network_id      # ID of network (in network configs)
    String       :network_node    # Network address of remote node
    String       :from            # From Header
    String       :to              # To Header
    String       :cc              # CC Header
    String       :bcc             # BCC Header
    String       :subject         # Subject Header
    text         :body            # Message
    TimeStamp    :composed        # Message composed timestamp
    TimeStamp    :received        # Message received by this system timestamp
    Array        :read_by         # Array of User_Id's that have read this article.
    end

#============================================================================
# Table: Fileareas
#============================================================================
    create_table(:fileareas) do
    primary_key  :id            # ID
    varchar      :name          # File Area Short Name
    Text         :description   # Short Description of Area
    Boolean      :read          # File Area is "READ" by users: list or download
    Boolean      :write         # File Area is "WRITE" by users: delete or upload
    varchar      :path          # Filesystem path to filestore
    TimeStamp    :created_at    # File Area Creation time
    end

#============================================================================
# Table: Files
#============================================================================
    create_table(:files) do
    primary_key  :id              # File ID
    integer      :tgfilearea_id   # Area ID
    integer      :owner_id        # File Owner (maintainer)
    integer      :uploaded_by     # User who submitted file
    integer      :approved_by     # User who approved file (if any)
    boolean      :enabled         # File available for download?
    String       :filename        # Filename
    String       :name            # Friendly Short Name
    text         :description     # Long description
    text         :checksum        # Some Checksum Value (MD5/SHA,etc)
    String       :version         # Version of file (optional)
    String       :vendor          # Vendor of the file (optional)
    String       :license         # License file distributed under (optional)
    String       :url             # URL for more information (optional)
    integer      :size            # Size of file in bytes on storage
    TimeStamp    :mtime           # File's mtime on storage
    TimeStamp    :created_at      # Time file added to DB
    TimeStamp    :modified_at     # Time file modified in DB
    end

#============================================================================
# Table: Inbox
#============================================================================
    create_table(:inbox) do
    primary_key  :id              # Mail ID
    integer      :user_id         # Owner ID
    integer      :from_id         # ID of sender
    boolean      :read            # ? Message Read or Unread
    boolean      :network         # ? Message is Local or Network
    integer      :network_id      # ID of network (in network configs)
    String       :network_node    # Network address of remote node
    String       :from            # From Header
    String       :to              # To Header
    String       :cc              # CC Header
    String       :bcc             # BCC Header
    String       :subject         # Subject Header
    text         :body            # Message
    TimeStamp    :composed        # Message composed timestamp
    TimeStamp    :received        # Message recieved timestamp
    TimeStamp    :read_at         # Time email first read
    end

#============================================================================
# Table: Bbslist
#============================================================================
    create_table(:bbslist) do
    primary_key  :id
    varchar      :bbsname
    Text         :description
    varchar      :sysopname
    varchar      :bbsurl
    varchar      :homepage
    varchar      :submitted_by
    TimeStamp    :created
    end

#============================================================================
# Table: Chatrooms
#============================================================================
    create_table(:chatrooms) do
    primary_key  :id
    varchar      :room
    varchar      :description
    integer      :limit
    TimeStamp    :created
    end

#============================================================================
# Table: Extprogs
#============================================================================
    create_table(:extprogs) do
    primary_key  :id
    varchar      :name
    varchar      :description
    varchar      :command
    TimeStamp    :created
    end

#============================================================================
  end
end
