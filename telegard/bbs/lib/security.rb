#!/opt/telegard/contrib/jruby/bin/jruby -W0
#!/usr/bin/env jruby
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

 Source File: /lib/security.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Security Library

-----------------------------------------------------------------------------
=end

=begin rdoc
= Security
Library for common security routines used in Telegard
=end

module Security

require 'yaml'
require 'rubygems'
require 'bcrypt'
require 'lib/rubyclass_extensions'

SecurityConfigFile = './conf/security.conf.yaml'

  # Define the structure of the Configuration File for Security.
  class Config

    def makedefault(filename)
      cfghash = {
              "uuid" => "todo",
              "secret" => Security::UserPassword.new.cryptpassword(rand.to_s).to_s }

      f = File.open(filename, "w")
      f.puts YAML::dump(cfghash)
      f.close
    end #/def makedefault

  end #/class Config

  # Handlers for user passwords stored in the database
  class UserPassword

    # Encrypt Password with BCrypt
    def cryptpassword(cleartxt)
       return BCrypt::Password.create(cleartxt)
    end

    # Validate a user password stored vs input
    def validate(input,stored)
       
    end

  end #/class UserPassword


  # Handlers for configuration passwords stored in plaintext yaml files/
  class ConfigPassword

    def initialize
      @security = File.open("./conf/security.conf.yaml")  { |yf| YAML::load( yf ) }
      @te = JasyptText::BasicTextEncryptor.new
      @te.setPassword(@security['secret'])
    end

    # Encrypt using the BBS unique secret as the salt
    def encrypt(cleartxt)      
      return @te.encrypt(cleartxt)
    end

    # Decrypt using the BBS unique secret as the salt
    def decrypt(crypted)
      return @te.decrypt(crypted)
    end

  end #/class ConfgPassword


end #/module Security


