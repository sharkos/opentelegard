=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/msgarea.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: MsgArea Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== File Areas Structure

=end

# Messsages Area Structure
class Tgmsgarea < Sequel::Model(:msgareas)
  Tgio.printstart " DB Model: msgareas"
  # => Create association of ONE Group to Many Users
  one_to_many :msgs

  if empty?
    # GENERAL : A default message group - Anyone can read, only members of "USERS" group (level 100) can write
    create  :name           => 'GENERAL',
            :description    => 'General user discussion on this system.',
            :network        => false,
            :network_id     => nil,
            :minlevel_read  => 1,
            :minlevel_write => 100,
            :enabled        => true,
            :created        => Time.now

    # TELEGARD : A default message group - Only members with group level >= 100 (USERS) can read and write
    create  :name           => 'TELEGARD',
            :description    => 'Telegard Software discussion.',
            :network        => false,
            :network_id     => nil,
            :minlevel_read  => 100,
            :minlevel_write => 100,
            :enabled        => true,
            :created        => Time.now

    # SYSADMINS : A default message group - Only members with group level >= 200 (COSYSOPS) can read or write
    create  :name           => 'SYSADMINS',
            :description    => 'System Administrators Only',
            :network        => false,
            :network_id     => nil,
            :minlevel_read  => 200,
            :minlevel_write => 200,
            :enabled        => true,
            :created        => Time.now

    # DISABLED : A default message group - set by default to "enabled == false"
    create  :name           => 'DISABLED',
            :description    => 'Sample area that should be hidden from view.',
            :network        => false,
            :network_id     => nil,
            :minlevel_read  => 1,
            :minlevel_write => 255,
            :enabled        => false,
            :created        => Time.now

    # TGNET_NEWS : A default TGNet network feed
    create  :name           => 'TGNET_NEWS',
            :description    => 'News from the Telegard Network',
            :network        => true,
            :network_id     => 1,
            :minlevel_read  => 1,
            :minlevel_write => -1,
            :enabled        => true,
            :created        => Time.now


  end #/if empty?
  Tgio.printreturn(0)
end
