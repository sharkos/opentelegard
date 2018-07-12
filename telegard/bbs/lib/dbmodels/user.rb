=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011   LeafScale Systems, LLC
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

 Source File: /lib/dbmodels/user.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: User Schema for Database

-----------------------------------------------------------------------------
=end

=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== User Structure
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


# User Class
class User < Sequel::Model(:users)

  require 'bcrypt'

  # Encrypt Password with BCrypt
  def self.cryptpassword(cleartxt)
    password = BCrypt::Password.create(cleartxt)
    return password
  end


  Tgio.printstart " DB Model: users"
  # => Create association of Many Users to ONE Group
  #many_to_one   :group

  set_schema do
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

  create_table unless table_exists?

  if empty?    
    create  :login => 'SYSOP',
            :islocked=> false,
            :group_id => 1,
            :password => self.cryptpassword('changeme'),
            :firstname => 'System',
            :lastname => 'Operator',
            :address1 => '10 Telegard Way',
            :address2 => 'suite 1',
            :city => 'LeafScale',
            :state => 'CO',
            :country => 'USA',
            :phone => '000-000-0000',
            :gender => 'M',
            :bday => '01/01/1970',
            :pwexpires => Time.now + 90.days,
            :created => Time.now,
            :login_last => Time.now,
            :sysopnote => 'This is the default all powerful User Account.',
            :login_failures => 0,
            :login_total => 0,
            :timebank => -1,
            :pwhint_question => "What is the meaning of life?",
            :pwhint_answer => "42",
            :pref_fastlogin   => false,
            :pref_term_height  => 24,
            :pref_term_width   => 80,
            :pref_term_pager  => true,
            :pref_term_color  => true,
            :pref_show_menus  => true,
            :pref_editor      => 'nano'

  end
  Tgio.printreturn(0)

  #  Quick validation for login or other routines to see if a specified user exists
  def self.exists?(username)
    user = self[:login=>username]
    if user.nil?
      return false
    else
      return true
    end
  end

  # Authorize a user by name. Passes in cleartxt version of password
  def self.authorize(username, cleartxtpw)
    user = self[:login=>username]
    unless user.nil?
      # Reject user if Group level is 255 or higher, or account is set to locked
      unless user.islocked == true || Group.find(:id => user.group_id).level <= 1
        dbpw = BCrypt::Password.new("#{user.password}")
        if dbpw == "#{cleartxtpw}"
          return {:result=>"true"}
        else
          user.set(:login_failures => user.login_failures+1)
          if user.login_failures >= $cfg['login']['lockout']
            user.set(:islocked => true)
          end
          user.save
          return {:result => "false", :failures => user.login_failures, :islocked=> user.islocked}
        end
      else
        return {:result => "locked"}
      end
    else
        return {:result=>"invalid"}
    end #/unless
  end

  # Clear login_failures count on a user
  def self.clearfailed(username)
    user = self[:login=>username]
    user.set(:islocked=>false, :login_failures=>0)
    user.save
  end

  # Count the login by incrementing the DB login_count and timestamp of login_last
  def self.countlogin(username)
    user = self[:login=>username]
    user.set(:login_total=>user.login_total+1, :login_last => Time.now)
    user.save
  end

  # Simple validator to compare 2 passwords in any presented format
  def self.validatepw(pw1, pw2)
    if pw1 == pw2
      return true
    else
      return false
    end
  end

end #/class User
