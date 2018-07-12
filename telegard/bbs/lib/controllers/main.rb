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

 Source File: /lib/controllers/main.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
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
          Telegard.unimplemented
        when "U" # User Menu
          UserController.new.menu
        when "?" # User Help
          HelpController.new.menu
      end #/case
      test_session
    end #/until
  end #/def menu
 
end