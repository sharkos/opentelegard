=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011,  LeafScale Systems, LLC
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

 Source File: /lib/controllers/user.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: User controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= UserController
The User controller handles user self-management functions.
=end

class UserController < Tgcontroller

  # Master menu for User Controller
  def menu
    done = false
    validkeys=['A','E','S','P','R','X']
    until done == true
      key = Tgio::Input.menuprompt('menu_user.ftl',validkeys, nil) # nil is for tpl vars hash
      print "\n"
      case key
        when "A" # Account summary (statistics)
          Telegard.unimplemented
        when "E" # Edit Account
          self.edit
        when "S" # Search for Users
          Telegard.unimplemented
        when "P" # Edit Preferences
          self.preferences
        when "R" # Reset Password
          newpw = Tglogin::Signup.askpassword
          $db[:users].filter(:id => $session.user_id).update(:password => User.cryptpassword(newpw))
        when "X" # Return to main
          return 0
      end #/case
    end #/until
  end #/def menu

  # Edit account menu
  def edit
    curuser = User.where(:id => $session.user_id).first
    done = false
    validkeys=['A','C','D','E','F','L','Q','S','Y','Z','.','X']
    until done == true
      key = Tgio::Input.menuprompt('user_edit_account.ftl',validkeys, { "user"=> Tgtemplate::Template.parse_hash(curuser.values)})
      print "\n"
      case key
        when "A" # Password Hint Answer
          curuser.pwhint_answer = Tglogin::Signup.askpwhint_answer
        when "C" # City
          curuser.city = Tglogin::Signup.askcity
        when "D" # Address lines 1 & 2
          curuser.address1 = Tglogin::Signup.askaddress1
          curuser.address2 = Tglogin::Signup.askaddress2
        when "E" # Email
          curuser.email = Tglogin::Signup.askemail
        when "F" # Firstname
          curuser.firstname = Tglogin::Signup.askfirstname
        when "L" # Lastname
          curuser.lastname = Tglogin::Signup.asklastname
        when "Q"
          curuser.pwhint_question = Tglogin::Signup.askpwhint_question
        when "S" # State
          curuser.state = Tglogin::Signup.askstate
        when "Y" # Country
          curuser.country = Tglogin::Signup.askcountry
        when "Z" # Postal Code
          curuser.postal = Tglogin::Signup.askpostal
        when "." # Quit without saving
          return 0
        when "X" # Return to main
          # Save user changes
          curuser.save
          return 0
      end #/case
    end #/until
  end #/def edit

  # User Preferences menu
  def preferences
    curuser = User.where(:id => $session.user_id).first
    done = false
    validkeys=['C','E','H','W','P','M','F','X','.']
    until done == true
      key = Tgio::Input.menuprompt('user_preferences.ftl',validkeys, { "user"=> Tgtemplate::Template.parse_hash(curuser.values)})
      print "\n"
      case key
        when "C" # Terminal Color
          curuser.pref_term_color = curuser.pref_term_color.toggle
        when "E" # Editor
          #curuser.pref_editor = select_editor
          Telegard.unimplemented
        when "H" # Terminal Height
          Telegard.unimplemented
          #curuser.pref_term_height = Tglogin::Signup.asktermheight
        when "W" # Terminal Width
          Telegard.unimplemented
          #curuser.pref_term_width = Tglogin::Signup.asktermwidth
        when "P" # Pager
          curuser.pref_term_pager = curuser.pref_term_pager.toggle
        when "M" # Menus
          curuser.pref_show_menus = curuser.pref_show_menus.toggle
        when "F"
          curuser.pref_fastlogin = curuser.pref_fastlogin.toggle
        when "." # Quit without saving
          return 0
        when "X" # Return to main
          # Save user changes
          curuser.save
          return 0
      end #/case
    end #/until
  end #/def preferences

  def select_editor
    done = false
    validkeys=['1']
    until done == true
      key = Tgio::Input.menuprompt('user_select_editor.ftl',validkeys,nil)
      print "\n"
      case key
        # Telegard Edit (this is deprecated)
        when "0" # Telegard Editor
          $session.pref_editor = 'tgedit'
          $session.save
          return 'tgedit'

        when "1" # GNU Nano
          $session.pref_editor = 'nano'
          $session.save
          return 'nano'

        when "2" # reserved
        when "3" # reserved
        when "4" # reserved
        when "5" # reserved
      end #/case
      return 0
    end #/until

  end

end