=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/filearea.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: File Area Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== File Areas Structure

=end


# Filearea Structure
class Tgfilearea < Sequel::Model(:fileareas)
  Tgio.printstart " DB Model: fileareas"
  # => Create association of ONE Group to Many Users
  one_to_many :tgfiles

  if empty?
    create  :name => 'dropbox',
            :description => 'Uploads (write-only)',
            :created_at => Time.now,
            :read => false,
            :write => true,
            :path => '/opt/bbsfs/dropbox'

    create  :name => 'default',
            :description => 'Default File Area',
            :created_at => Time.now,
            :read => true,
            :write => false,
            :path => '/opt/bbsfs/default'

  end
  Tgio.printreturn(0)
end #/class Tgfilearea
