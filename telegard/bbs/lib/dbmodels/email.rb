=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/email.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Email Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== Email Structure
 Email data is split between various tables in the database
=end


# Email Structure (must be named Tgemail)
class TgemailInbox < Sequel::Model(:inbox)
  Tgio.printstart " DB Model: email - inbox"
  # => Create association of ONE Group to Many Users

  many_to_one :user

  if empty?
    # Test data for DropBox - Criteria = New Uploaded file, not approved nor enabled. SHA256 Checksum used.
    create  :user_id => '1',
            :from_id => '1',
            :read => false,
            :network => false,            
            :from => 'Telegard/2 Project Team',
            :to => 'NEW SYSOP',
            :subject => 'Welcome to Telegard/2 - a note from the developer.',
            :composed => Time.now,
            :received => Time.now,
            :read_at => nil,
            :body => <<eol
Hello!

Welcome to the Telegard/2 Operating Subsystem. This software is the result
of years of hard work and dedication by the project's team of developers.
We hope that you will enjoy the features and innovation of this product.
This email is auto-generated one time only, and dropped into the Inbox of
the master user or SYSOP account during installation.

Information on using this software is always available on the main project
website: http://www.telegard.org  and on IRC  #telegard @ irc.FreeNode.net

Have fun! And be sure to stay updated on the latest releases, and changes.

Sincerely,
Chris Tusa
inet:  chris.tusa@opentg.org
tgnet: <coming soon>
eol

  end
  Tgio.printreturn(0)
end
