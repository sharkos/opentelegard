=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/help.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Help Menu controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= HelpController
The Help Menu controller.
=end

# Help Controller Class
class HelpController < Tgcontroller

  def menu
    done = false
    validkeys=['A','B','C','F','H','M','P','T','U','S', 'X']
    until done == true
      key = Tgio::Input.menuprompt('menu_help.ftl',validkeys, nil) # nil is for tpl vars hash
      test_session
      print "\n"
      case key
        when "A" # About Telegard         
          Tgtemplate.display('help_about.ftl', nil)
        when "B" # BBS Lists Help
          Tgtemplate.display('help_bbslists.ftl', nil)          
        when "C" # Chat Rooms Help
          Tgtemplate.display('help_chat.ftl', nil)
        when "F" # File Areas Help
          Tgtemplate.display('help_fileareas.ftl', nil)
        when "H" # Call History Help
          Tgtemplate.display('help_callhistory.ftl', nil)
        when "M" # Messages Areas Help
          Tgtemplate.display('help_msgareas.ftl', nil)
        when "P" # Page Sysop Help
          Tgtemplate.display('help_pagesysop.ftl', nil)
        when "T" # Timebank Help
          Tgtemplate.display('help_timebank.ftl', nil)
        when "U" # User Menu Help
          Tgtemplate.display('help_useraccount.ftl', nil)
        when "S" # Command Summary
          Tgtemplate.display('help_commands.ftl', nil)
        when "X" # Return to Main
          done = true          
      end #/case
      test_session
    end #/until
    return 0
  end #/def menu
 
end
