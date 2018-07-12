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

 Source File: /lib/tglogin/signup.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Handlers for Newuser Signup Routine

-----------------------------------------------------------------------------
=end

=begin rdoc
= Tglogin::Signup (New User Signup Routines)
Contains the methods required to create a new user.
== Configuration Variables (see opentg.conf) $cfg['login']
login:
  allownew: true

allownew:boolean - will the login routine accept new users?

=end

#### TODO: ALL SIGNUP NEEDS VALIDATION

module Tglogin
  module Signup

    # Asks user for their login name or Alias.
    def Signup::asklogin(val=nil)
      complete = false
      until complete == true
        Tgtemplate::display('signup_asklogin.ftl')
        login = Tgio::Input::loginform
          # login = Tgio::question('signup_asklogin.ftl', 16)
        # Validate Login Name
        unless login.is_blank? || login.minlength?(4) == false
          if User[:login => login.upcase].nil?            
            complete = true if login.is_alphanumeric?
          else
            print "\n"
            Tgtemplate::display('signup_login_taken.ftl')
            print "\n\n"
          end #/if
        else
          print "\n"
          Tgtemplate::display('signup_login_invalid.ftl')
          print "\n\n"
        end #/unless
      end #/until
      return login.upcase
    end #/def asklogin

    # Asks user for their first name.
    def Signup::askfirstname(val=nil)
      complete = false
      until complete == true
        firstname = Tgio::question('signup_askfirstname.ftl', 25)
        unless firstname.is_blank? || firstname.minlength?(3) == false
          complete = true if firstname.is_alpha?
        end #/if
      end #/until
      return firstname.capitalize
    end #/def asklogin

    # Asks user for their last name.
    def Signup::asklastname(val=nil)
      complete = false
      until complete == true
        lastname = Tgio::question('signup_asklastname.ftl', 25)
        unless lastname.is_blank? || lastname.minlength?(2) == false
          complete = true if lastname.is_alpha?
        end #/if
      end #/until
      return lastname.capitalize
    end #/def asklogin

    # Asks user for their email address
    def Signup::askemail(val=nil)
      complete = false
      until complete == true
        email = Tgio::question('signup_askemail.ftl', 60)
        unless email.is_blank?
          complete = true if email.is_email?
        end #/if
      end #/until
      return email
    end #/def askemail

    # Asks user for their address line 1
    def Signup::askaddress1(val=nil)
      if $cfg['signup']['ask_address'] == true
        complete = false
        until complete == true
          address1 = Tgio::question('signup_askaddress1.ftl', 40)
          unless address1.is_blank? || address1.minlength?(3) == false
            complete = true
          end #/if
        end #/until
        return address1
      else
        return nil
      end
    end #/def askaddress1

    # Asks user for their address line 2
    def Signup::askaddress2(val=nil)
      if $cfg['signup']['ask_address'] == true
        complete = false
        until complete == true
          address2 = Tgio::question('signup_askaddress2.ftl', 40)          
          if address2.is_blank? || address2.is_spaced_alphanumeric?
            complete = true
          end #/if
        end #/until
        return address2
      else
        return nil
      end
    end #/def askaddress2

    # Asks user for their city
    def Signup::askcity(val=nil)
      complete = false
      until complete == true
        city = Tgio::question('signup_askcity.ftl', 30)
        unless city.is_blank? || city.minlength?(3) == false
          complete = true if city.is_spaced_alpha?
        end #/if
      end #/until
      return city.capitalize
    end #/def askcity

    # Asks user for their state
    def Signup::askstate(val=nil)
      complete = false
      until complete == true
        state = Tgio::question('signup_askstate.ftl', 5)
        unless state.is_blank?  || state.minlength?(2) == false
          complete = true if state.is_alpha?
        end #/if
      end #/until
      return state.upcase
    end #/def askstate

    # Asks user for their postalcode
    def Signup::askpostal(val=nil)
      if $cfg['signup']['ask_postal']  == true
        complete = false
        until complete == true
          postal = Tgio::question('signup_askpostal.ftl', 10)
          unless postal.is_blank?
            complete = true if postal.is_alphanumeric?
          end #/if
        end #/until
        return postal
      else
        return nil
      end
    end #/def askpostal

    # Asks user for their country
    def Signup::askcountry(val=nil)
      if $cfg['signup']['ask_country'] == true
        complete = false
        until complete == true
          country = Tgio::question('signup_askcountry.ftl', 5)
          unless country.is_blank?
            complete = true if country.is_alpha?
          end #/if
        end #/until
        return country.upcase
      else
        return nil
      end
    end #/def askcountry

    # Asks user for their phone
    def Signup::askphone(val=nil)
      if $cfg['signup']['ask_phone']   == true
        complete = false
        until complete == true
          phone = Tgio::question('signup_askphone.ftl', 18)
          unless phone.is_blank?
            complete = true
          end #/if
        end #/until
        return phone
      else
        return nil
      end
    end #/def askstate

    # Asks user for their gender
    def Signup::askgender
      if $cfg['signup']['ask_gender']  == true
        complete = false
        until complete == true
          gender = Tgio::Input::inputgender('signup_askgender.ftl')
          unless gender.nil?
            complete = true
          end #/if
        end #/until
        return gender
      else
        return nil
      end
    end #/def askstate

    # Asks user for their bday YYYY/MM/DD
    def Signup::askbday
      if $cfg['signup']['ask_bday']    == true
        Tgtemplate::display('signup_askbday.ftl')
        bday = Tgio::Dates::inputdate

        return bday
      else
        return nil
      end
    end #/def askbday

    # Asks user for their password.
    def Signup::askpassword
      complete = false
      until complete == true
        pwentry1 = false
        pwentry2 = false
        entry1 = nil
        entry2 = nil
        password = nil

        until pwentry1 == true
          Tgtemplate::display('signup_askpassword.ftl')
          entry1 = Tgio::Input::passwordform
          unless entry1.is_blank? || entry1.minlength?(6) == false
            pwentry1 = true
          end #/if
        end #/until entry1

        until pwentry2 == true
          Tgtemplate::display('signup_confirmpassword.ftl')
          entry2 = Tgio::Input::passwordform
          unless entry2.is_blank? || entry2.minlength?(6) == false
            pwentry2 = true
          end #/if
        end #/until entry1

        if entry1 == entry2 then
          complete = true
          password = entry1
        else
          Tgtemplate::display('signup_passwordmismatch.ftl')
        end

      end #/until complete

      return password
    end #/def askpassword

    # Asks user for their pw hint question
    def Signup::askpwhint_question(val=nil)
      complete = false
      until complete == true
        pwhintq = Tgio::question('signup_askpwhint_question.ftl', 75)
        unless pwhintq.nil? || pwhintq.is_blank?
          complete = true
        end #/if
      end #/until
      return pwhintq
    end #/def askpwhint_question

    # Asks user for their pw hint answer
    def Signup::askpwhint_answer(val=nil)
      complete = false
      until complete == true
        pwhinta = Tgio::question('signup_askpwhint_answer.ftl', 75)
        unless pwhinta.nil? || pwhinta.is_blank?
          complete = true
        end #/if
      end #/until
      return pwhinta
    end #/def askpwhint_question

    # Asks user a operator designated question
    def Signup::askcustom(num=1,val=nil)
      complete = false
      case num
        when 1
          q = {'question' => $cfg['signup']['custom1']}
        when 2
          q = {'question' => $cfg['signup']['custom2']}
        when 3
          q = {'question' => $cfg['signup']['custom3']}
      end
      until complete == true
        Tgtemplate::display('signup_askcustom.ftl', q)
        custom = Tgio::Input::inputform(75)
        unless custom.nil? || custom.is_blank?
          complete = true
        end #/if
      end #/until
      return custom
    end #/def askpwhint_question


    # Displays a confirmation screen and allows the caller to change
    # their account settings before creating the account
    def Signup::confirm(signupdata)
      dosave = false
      #Tgtemplate::display('signup_confirmdata.ftl', signupdata)
      validkeys=['A','B','C','D','E','F','G','L','P','Q','R','S','U','Y','Z','1','2','3','X']
      until dosave == true
        key = Tgio::Input.menuprompt('signup_confirmdata.ftl',validkeys,signupdata)
        print "\n"
        case key
          when 'A' # Hint Answer
            signupdata['pwhint_answer'] = self.askpwhint_answer
          when 'B' # Birthdate
            signupdata['bday'] = self.askbday
          when 'C' # City
            signupdata['city'] = self.askcity
          when 'E' # Email
            signupdata['email'] = self.askemail
          when 'F' # First Name
            signupdata['firstname']=self.askfirstname
          when 'G' # Gender
            signupdata['gender']=self.askgender
          when 'L' # Last Name
            signupdata['firstname']=self.asklastname
          when 'P' # Password
            signupdata['password']=self.askpassword
          when 'Q' # Hint Question
            signupdata['pwhint_question']=self.askpwhint_question
          when 'S' # State
            signupdata['state']=self.askstate
          when 'U' # Login Alias
            signupdata['login']=self.asklogin
          when 'Y' # Country
            signupdata['country']=self.askcountry
          when 'D' # Address Line 1 & 2
            signupdata['address1']=self.askaddress1
            signupdata['address2']=self.askaddress2
          when 'Z' # Zipcode/Postal
            signupdata['postal']=self.askpostal
          when '1' # Custom Question 1
            signupdata['custom1']=self.askcustom(1)
          when '2' # Custom Question 2
            signupdata['custom2']=self.askcustom(2)
          when '3' # Custom Question 3
            signupdata['custom3']=self.askcustom(3)
          when 'X' # Exit & Save
            dosave = true
            gid = Group.find(:name => $cfg['signup']['default_group'].upcase).id
            User.create(
              :login            => signupdata['login'],
              :firstname        => signupdata['firstname'],
              :lastname         => signupdata['lastname'],
              :password         => User.cryptpassword(signupdata['password']),
              :address1         => signupdata['address1'],
              :address2         => signupdata['address2'],
              :city             => signupdata['city'],
              :state            => signupdata['state'],
              :postal           => signupdata['postal'],
              :country          => signupdata['country'],
              :phone            => signupdata['phone'],
              :gender           => signupdata['gender'],
              :email            => signupdata['email'],
              :custom1          => signupdata['custom1'],
              :custom2          => signupdata['custom1'],
              :custom3          => signupdata['custom1'],
              :sysopnote        => nil,
              :pwhint_question  => signupdata['pwhint_question'],
              :pwhint_answer    => signupdata['pwhint_answer'],
              :bday             => signupdata['bday'],
              :pwexpires        => Time.now+90.days,
              :group_id         => gid,
              :timebank         => 0,
              :total_files_up   => 0,
              :total_files_down => 0,
              :total_messages   => 0,
              :login_failures   => 0,
              :login_total      => 1,
              :login_last       => Time.now,
              :pref_fastlogin   => false,
              :pref_term_height  => 24,
              :pref_term_width   => 80,
              :pref_term_pager  => true,
              :pref_term_color  => true,
              :pref_show_menus  => true,
              :pref_editor      => 'nano',
              :created          => Time.now
            ) # /User.create
          # TODO: Catch/throw for Sequel create errors  
          Tgtemplate::display('signup_saved.ftl')
        end #/case
      end #/until
      # Create Account
      
    end #/def

  end #/Signup
end #/Tglogin