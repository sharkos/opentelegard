=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/user.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
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
            :sysopnote => 'This is the all powerful admin account.',
            :login_failures => 0,
            :login_total => 0,
            :timebank => 0,
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

  # Test if the user exists in the database
  # Use-case: Validation for login or other routines to see if a specified user exists
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
