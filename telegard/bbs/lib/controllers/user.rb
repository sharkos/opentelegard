=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/user.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
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
