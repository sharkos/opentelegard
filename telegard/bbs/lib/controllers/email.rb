=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011   LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2008-2011, LeafScale Systems, LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of LeafScale Systems nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.


---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/email.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
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