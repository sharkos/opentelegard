=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/tgcontroller.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Master Controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= Tgcontroller (Main Controller)
Tgcontroller is the master application controller. Other Controllers inherit
from this SuperClass.
=end

# Main Controller Class
class Tgcontroller

  # This tests if the users' session is still good (such as: time expired)
  def test_session
    unless $session.is_valid?
      Telegard::goodbye_fast
    end
  end


end

#
# List inherited controllers:
#
require 'lib/controllers/main'
require 'lib/controllers/callhistory'
require 'lib/controllers/chat'
require 'lib/controllers/chatroom'
#require 'lib/controllers/email' # No Longer used, merged into MSGAREAS, but the code is decent for review at some point.
require 'lib/controllers/file'
require 'lib/controllers/filearea'
require 'lib/controllers/message'
require 'lib/controllers/messagearea'
require 'lib/controllers/timebank'
require 'lib/controllers/user'
require 'lib/controllers/help'
require 'lib/controllers/bbslist'
