#!/opt/telegard/contrib/jruby/bin/jruby -W0
#!/usr/bin/env jruby
=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/security.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
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


