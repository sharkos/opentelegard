=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/chatroom.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Chatroom Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== ChatRoom Structure

=end


# Chat Room Structure
class Tgchatroom < Sequel::Model(:chatrooms)
  Tgio.printstart " DB Model: chatrooms"

  if empty?
    #create  :label => 'value'
  end
  Tgio.printreturn(0)
end
