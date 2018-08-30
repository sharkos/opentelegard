=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/email.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Email controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= EmailController
The Email controller.
=end

class EmailController < Tgcontroller

  # Email main menu handler
  def menu
    done = false
    validkeys=['A','C','I','O','S','X']
    until done == true
      unread = Tgemail.filter(:user_id => $session.user_id).count
      key = Tgio::Input.menuprompt('menu_email.ftl',validkeys, {"unread" => unread.to_s}) # tgni = TG Not Implemented
      print "\n"
      case key
        when "A" # List archived mail
          Telegard.unimplemented
        when "C" # Compose new mail
          Telegard.unimplemented
        when "I" # Inbox navigator
          self.navigator('inbox')
        when "O" # List Outbox
          Telegard.unimplemented
        when "S" # Search Email
          Telegard.unimplemented
        when "X" # Return to main
          done = true
          return 0
      end #/case
    end #/until
  end #/def menu

  # Email Navigator - a generic interface to reading email messages. Function takes a "folder" name
  def navigator(folder)
    done = false
    validkeys=['A','D','F','H','L','R','V','X', '?']
    until done == true
      unread = Tgemail.filter(:user_id => $session.user_id).count
      key = Tgio::Input.menuprompt('menu_email_inbox.ftl',validkeys, {"unread" => unread.to_s}) # tgni = TG Not Implemented
      print "\n"
      case key
        when "A" # Archive
        when "L" # List Inbox
          self.inbox_list
        when "X" # Return to email menu
          done = true
          return 0
      end #/case
    end #/until
  end #/def

  # List contents of the user's Inbox
  def inbox_list
    inbox =  Tgtemplate::Template.parse_dataset($db[:email].filter(:user_id => $session.user_id).all)
    Tgtemplate.display('email_list_inbox.ftl', {'emails' => inbox})
  end
  
  # Interactive Message Reader
  def read_msg

  end

end
