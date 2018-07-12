=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
                  Copyright (C) 2010, LeafScale Systems, LLC
                            http://www.opentg.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2010, LeafScale Systems, LLC
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

 Source File: /lib/tglogin.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Handlers for Login/Logout

-----------------------------------------------------------------------------
=end

=begin rdoc               
= Tglogin (Login/Logout Routines)
Tglogin handles the procedures for logging into Telegard.
== Configuration Variables (see opentg.conf) $cfg['login']
login:
  attempts: 3
  lockout: 5
  usehint: true

attempts:integer - number of failed attempts to allow before disconnecting.
lockout: integer - number of failed attempts for a single user before setting account to is_locked = true.
usehint: boolean - whether to prompt user for password hint on last attempt before lockout.
allownew:boolean - will the login routine accept new users?  

=end

require 'lib/tglogin/signup'

module Tglogin

  require 'lib/tgtemplate'
  require 'bcrypt'
  @logincfg = $cfg['login']

  # Displays the template for the login banner.
  def Tglogin::banner
    Tgtemplate::display('login_banner.ftl', {"allownew" => @logincfg['allownew'].to_s})
  end

  # Username prompt - displays template, calls highline ask and returns username.
  def Tglogin::userprompt
    Tgtemplate::display('login_prompt_user.ftl')
    username = Tgio::Input::loginform
    if username.upcase == "NEW"
      if @logincfg['allownew'] == true
        username = self.signup
      else
        Tgtemplate::display('login_new_disabled.ftl')
        return nil
      end
    end
    # check if the username exists in the DB so as not to waste resources on nonexistent accounts.
    if User.exists?(username) == true
      return username
    else
      
      return nil
    end
  end

  # Password prompt - displays template, calls highline ask and returns crypted password.
  def Tglogin::passwordprompt
    t = Tgtemplate::Template.new('login_prompt_password.ftl')
    t.render()
    cleartxt = Tgio::Input::passwordform
    return cleartxt
  end

  # Encrypt the clear text password
  def Tglogin::cryptpassword(cleartxt)
    password = BCrypt::Password.create(cleartxt)
    return password
  end

  def Tglogin::askhint(login)
    question = User[:login => login].pwhint_question
    t = Tgtemplate::Template.new('login_prompt_pwhint.ftl')
    t.render("pwhint_question"=>question)
    answer = Tgio::Input::inputform(75)
    dbanswer   = User[:login => login].pwhint_answer

    if answer == dbanswer
      puts "VALIDATED - CLEARING LOGIN FAILURES"
      User.clearfailed(login)
      return true
    else
      puts "INCORRECT"
      return false
    end

  end

  # This function provides the entire login routine logic. Configuration variables apply.
  def Tglogin::auth
    self.banner
    attempt = 0
    while attempt < @logincfg['attempts'] do
      login = self.userprompt
      unless login.nil?
        password = self.passwordprompt
        thistry = User.authorize(login, password)
        case thistry[:result]
          # If user is validated and allowed, then return true and create a session.
          when "true"
            User.countlogin(login)
            User.clearfailed(login)
            user = User[:login => login]
            group = Group[:id => user.group_id]

            # Create caller history entry & update session
            $callerid = Tgcallhistory.create(
                    :user_id => user.id,
                    :alias  => user.login,
                    :time_login => Time.now
                    )

            timeremain = (group.dailytimelimit - $callerid.thisuser_time_today)

            # Create global session variable
            $session = Session.new
                $session.user_id    = user.id
                $session.username   = login
                $session.group_id   = user.group_id
                $session.level      = group.level
                $session.created    = Time.now
                $session.expires    = Time.now + 1.hours
                $session.caller_id  = $callerid.id
                $session.filearea   = nil # Set the filearea tracking to nil. Initialized in FileAreaController.menu
                $session.msgarea    = nil  # Set the filearea tracking to nil. Initialized in MsgAreaController.menu
                $session.chatroom   = nil  # Set the filearea tracking to nil. Initialized in ChatRoomController.menu
                $session.expires    = Time.now + timeremain.minutes

                # User preferences go into session so we dont have to query the DB every time.
                $session.pref_show_menus = user.pref_show_menus
                $session.pref_term_pager = user.pref_term_pager
                $session.pref_editor     = user.pref_editor
            $session.save
            # TODO: BUG#:  581982 - $session does not seem to know its record ID in the table on the very first login only.
            # TODO: Test if retrieving the saved record back as a dataset will solve this problem.


            if timeremain <= 0
              Tgtemplate::display('login_dailylimit.ftl')
              Telegard::goodbye_fast
            else
              Tgtemplate::display('login_session_info.ftl', {
                      'timetoday' => $callerid.thisuser_time_today.to_s,
                      'grouplimit'=> group.dailytimelimit.to_s,
                      'logintoday'=> $callerid.thisuser_logincount_today.to_s,
                      'curtime'   => Time.now.to_s,
                      'expires'   => $session.expires.to_s,
                      'timeremain'=> timeremain })

            end
            return true
            break
          when "false"
            attempt += 1
            Tgtemplate::display('login_failed.ftl', {"attempt" => "#{attempt.to_s}", "maxattempts" => "#{@logincfg['attempts'].to_s}","failures"=> thistry[:failures].to_s})
            # Test if user.login_failures is equal to 1 less than the configured lockout.
            # If so, prompt user for PWHINT if configured
            if thistry[:failures] == @logincfg['lockout'] && @logincfg['usehint'] == true
              self.askhint(login)
            end
          # -> Chances are, we will NEVER get to this ' when "invalid" ' clause. But if for some reason we do, handle it.
          when "invalid"
            attempt += 1
            print "\n"
            Tgtemplate::display('login_invalid.ftl', tvars = {"attempt" => "#{attempt.to_s}", "maxattempts" => "#{@logincfg['attempts'].to_s}"})
          when "locked"
            print "\n"
            Tgtemplate::display('login_locked_user.ftl', {"attempt" => "#{attempt.to_s}", "maxattempts" => "#{@logincfg['attempts'].to_s}"})
        end #/case
      else # If login is NIL, its an invalid login. Do some stuff here  (Same as case when invalid above)
        attempt += 1
        print "\n"
        Tgtemplate::display('login_invalid.ftl', {"attempt" => "#{attempt.to_s}", "maxattempts" => "#{@logincfg['attempts'].to_s}", "allownew" => "#{@logincfg['allownew']}"})
      end #/unless login.nil?
    end #/while
    # Return nil as a failsafe.
    return nil
  end # end def auth

  # Signup routine for New Users
  def Tglogin::signup
    cfg = $cfg['signup']
    Tgio::ansiclear
    JLine::ConsoleReader.new.set_use_pagination(true)
    Tgtemplate::display('signup_instructions.ftl', {"bbs"=>$cfg['bbs']})
    unless Tgio::Input::inputyn('signup_askcontinue.ftl') == true
      puts "Goodbye!"
      exit 0
    end

    Tgtemplate::display('signup_aup.ftl', {"bbs"=>$cfg['bbs']})
    if Tgio::Input::inputyn('signup_accept_aup.ftl') == true
      # Ask required questions
      login     = Tglogin::Signup::asklogin
      firstname = Tglogin::Signup::askfirstname
      lastname  = Tglogin::Signup::asklastname
      email     = Tglogin::Signup::askemail
      password  = Tglogin::Signup::askpassword
      pwhint_question  = Tglogin::Signup::askpwhint_question
      pwhint_answer    = Tglogin::Signup::askpwhint_answer
      address1  = Tglogin::Signup::askaddress1
      address2  = Tglogin::Signup::askaddress2
      city      = Tglogin::Signup::askcity
      state     = Tglogin::Signup::askstate
      postal    = Tglogin::Signup::askpostal
      country   = Tglogin::Signup::askcountry
      phone     = Tglogin::Signup::askphone
      gender    = Tglogin::Signup::askgender
      bday      = Tglogin::Signup::askbday
      custom1   = Tglogin::Signup::askcustom(1) if cfg['ask_custom1'] == true
      custom2   = Tglogin::Signup::askcustom(2) if cfg['ask_custom2'] == true
      custom3   = Tglogin::Signup::askcustom(3) if cfg['ask_custom3'] == true

      # Send to review screen
      signupdata = {
        "login" => login,
        "password" => password,
        "pwhint_question" => pwhint_question,
        "pwhint_answer" => pwhint_answer,
        "firstname" => firstname,
        "lastname" => lastname,
        "email" => email,
        "city" => city,
        "state" => state,
        "country" => country,
        "address1" => address1,
        "address2" => address2,
        "postal" => postal,
        "phone" => phone,
        "gender" => gender,
        "bday" => bday.to_s,
        "custom1" => custom1,
        "custom2" => custom2,
        "custom3" => custom3,
        "pwexpires" => (Time.now + 90.days).to_s
      }
      Tglogin::Signup::confirm(signupdata)
    else
      puts "Goodybye!"
      exit 0
    end
    # Send login name back to login. 
    return login
  end #/dev signup



end # => /module