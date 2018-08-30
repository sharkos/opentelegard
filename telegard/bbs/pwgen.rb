#!/opt/telegard/contrib/jruby/bin/jruby -W0
#!/usr/bin/env jruby
=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /pwgen.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Password Generator for Telegard

-----------------------------------------------------------------------------
=end

=begin rdoc
= Pwgen
Program to generate encrypted string passwords for Telegard Configuration Files & Database entries
=end

unless File.exists?('conf/security.conf.yaml')
  puts "File 'conf/security.conf.yaml' does not exist \n (or)\nyou are calling this program from outside the Telegard BBS directory."
  exit 1
end


require 'yaml'
require 'rubygems'
require 'bcrypt'
require 'lib/tgconstants'
require 'lib/security'

# Get the password text
def getpwentry
  tr = JLine::ConsoleReader.new
  echochar = JavaLang::String.new("%").charAt(0)
  #tr.setEchoCharacter(echochar)
  match = false

  until match == true
    pw1 = tr.readLine("Password: ", echochar)
    pw2 = tr.readLine("Confirm : ", echochar)
    if pw1 == pw2
      match = true
      puts "\nEncrypted version:\n"
    else
      puts "\nERROR: Passwords did not match! Please try again.\n\n"
      pw1 = nil
      pw2 = nil
    end
  end
  return pw2
end

# Encrypt Password with BCrypt
def cryptpassword(mode, cleartxt)
  case mode
    when 'user'
      return Security::UserPassword.new.cryptpassword(cleartxt)
    when 'config'
      return Security::ConfigPassword.new.encrypt(cleartxt)
  end
end


require 'optparse'
def getoptions(args)

	options = {}

	opts = OptionParser.new do |opts|
        opts.banner = "OpenTelegard/2 :: Copyright (c) 2008-2010, Chris Tusa.\nDistributed by LeafScale Systems, All rights reserved.\n
The password generator takes cleartext password input
and returns a hashed output for use within Telegard.\nusage:\n"
        opts.separator ""

	opts.on("-c", "--config", "Format used by configuration files.") do |g|
		options[:config] = g
	end

	opts.on("-u", "--userdb", "Format used by database table 'users'.") do |l|
		options[:userdb] = l
    end
   opts.on_tail("-h", "--help", "Show this help message.") do |h|
	 puts opts; return 0
	end
  end  # end opts do

  begin opts.parse!
   rescue OptionParser::InvalidOption => invalidcmd
		puts "Invalid command options specified: #{invalidcmd}"
		puts opts
		return 1
	rescue OptionParser::ParseError => error
		puts error
  end # end begin

    # DEFAULT BEHAVIOR
	if options.empty? == true
		puts opts
	end
  options
end	# end def

cmdswitch = getoptions(ARGV)

if cmdswitch.size > 1
  puts "note: #{$0} can only accept a single argument switch."
else
  # -> Switch: -c  :  Generate password hashes for storing in Config
  if cmdswitch[:config]
    puts cryptpassword('config', getpwentry)
    puts "\n"
  end

  if cmdswitch[:userdb]
    puts cryptpassword('user', getpwentry)
    puts "\n"
  end


end



