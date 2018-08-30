=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/msg.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Msg Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== Msg Structure

=end


# Message Post Structure
class Tgmsg < Sequel::Model(:msgs)
  Tgio.printstart " DB Model: mgs"
  # => Create association of ONE Group to Many Users
  many_to_one :msgarea

  if empty?
    #create  :label => 'value'
  end
  Tgio.printreturn(0)
end

