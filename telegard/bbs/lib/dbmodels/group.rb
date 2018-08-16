=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
                  Copyright (C) 2010, LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2010, Chris Tusa & LeafScale Systems, LLC
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

 Source File: /lib/dbmodels/group.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
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
end #/class Group
