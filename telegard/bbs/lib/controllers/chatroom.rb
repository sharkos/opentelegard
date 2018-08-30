=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/chatroom.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: ChatRoom controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= ChatRoom Controller
The Chat Room Controller
=end

class ChatRoomController < Tgcontroller

  def menu
    done = false
    validkeys=['/G']
    until done == true
      key = Tgio::Input.menuprompt('menu_chatroom.ftl',validkeys, nil) # nil is for tpl vars hash
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
