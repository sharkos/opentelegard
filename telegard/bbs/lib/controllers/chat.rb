=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/chat.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Chat controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= ChatController
The Chat Menu controller.
=end

class ChatController < Tgcontroller

  def menu
    done = false
    validkeys=['/G']
    until done == true
      key = Tgio::Input.menuprompt('menu_chat.ftl',validkeys, nil) # nil is for tpl vars hash
      print "\n"
      case key
        when "/G"
          puts "Goodbye!"
          done = true
          return 0
      end #/case
    end #/until
  end #/def menu
 
end
