=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/extprogs.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: External Programs Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== ExtProgs Structure

=end

# External Programs (DOORS) Structure
class Tgextprogs < Sequel::Model(:extprogs)
  Tgio.printstart " DB Model: extprogs"

  if empty?
    #create  :label => 'value'
  end
  Tgio.printreturn(0)
end
