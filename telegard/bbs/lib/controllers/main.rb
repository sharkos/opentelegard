=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/main.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Main Menu controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= MainController
The Main Menu master controller.
=end

# Main Controller Class
class MainController < Tgcontroller

  def menu
    done = false
    validkeys=['A','B','C','E','F','G','H','M','P','T','U','?']
    until done == true
      key = Tgio::Input.menuprompt('menu_main.ftl',validkeys, nil) # nil is for tpl vars hash
      test_session
      print "\n"
      case key
        when "A" # AutoMessage
          Telegard.unimplemented
        when "B" # BBS Lists
          BBSlistController.new.menu
        when "C" # Chat Rooms
          Telegard.unimplemented
        when "E" # Email Tools
          #EmailController.new.menu
          Telegard.unimplemented
        when "F" # File Areas
          FileAreaController.new.menu
        when "G" # Good Bye
          Telegard::goodbye          
        when "H" # Call History
          CallHistoryController.new.menu
        when "M" # Messages Areas
          MsgareaController.new.menu
        when "P" # Page Sysop
          Telegard.unimplemented
        when "T" # Timebank
          TimebankController.new.menu
        when "U" # User Menu
          UserController.new.menu
        when "?" # User Help
          HelpController.new.menu
      end #/case
      test_session
    end #/until
  end #/def menu
 
end
