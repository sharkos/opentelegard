=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/tgconfig.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Configuration Handlers

-----------------------------------------------------------------------------
=end

=begin rdoc               
= Tgconfig (Configuration)
Tgconfig handles configuration file management Configuration is stored in YAML syntax formatting.
=end


module Tgconfig
  require 'yaml'
  require 'rubygems'
  require 'bcrypt'
  require 'lib/security'

  Configfile = "./conf/telegard.conf.yaml"

  # Builds a default YAML configuration and outputs the filename specified.
  def Tgconfig.makedefault(filename)
    cfghash = {
            "bbs" => {
                    "name"    => "Telegard/2 BBS",
                    "tagline" => "Another Installation of OpenTelegard/2",
                    "theme"   => "opentg",
                    "enabled" => true
            },
            "database" => {
                    "type"    => "embedded",
                    "driver"  => "jdbc:h2",
                    "host"    => "localhost",
                    "name"    => "opentg",
                    "user"    => "sa",
                    "pass"    => Security::ConfigPassword.new.encrypt("changeme")
            },
            "login" => {
                    "attempts"=> 5,
                    "lockout" => 8,
                    "usehint" => true,
                    "allownew" => true
            },
            "signup" => {
                    "default_group" => "USERS",
                    "ask_address" => true,
                    "ask_postal" => true,
                    "ask_country" => true,
                    "ask_phone" => true,
                    "ask_gender" => true,
                    "ask_bday" => true,
                    "ask_custom1" => true,
                    "custom1" => "How did you hear about us? (75 chars max)",
                    "ask_custom2" => false,
                    "custom2" => "",
                    "ask_custom3" => false,
                    "custom3" => ""
            },
            "notify" => {
                    "notify_user" => true,
                    "user_name" => "SYSOP",
                    "notify_group" => true,
                    "group_name" => "SYSOPS",
                    "on_signup" => true,
                    "on_bbslist_submission" => true,
                    "on_user_lockout" => true
                    },
            "feature" => {
                    "bbslist" => true
                    },
            "limits" => {
                    "timebank_max" => 300,
                    "files_upload_max" => 1024 
                    }

    }
    f = File.open(filename, "w")
    f.puts YAML::dump(cfghash)
    f.close
  end

  # Load in the YAML configuration file and returns
  def Tgconfig.load
    cfg = File.open(Configfile)  { |yf| YAML::load( yf ) }
    # => Ensure loaded data is a hash. ie: YAML load was OK
    if cfg.class != Hash
       raise "ERROR: Tgconfig - invalid format or parsing error."
    # => If all is well, perform deeper validation
    else
      # => PARSE & CHECK: Database Section
      if cfg['database'].nil?
        raise "ERROR: Tgconfig - database section not defined."
      else
        case cfg['database']['type']
          when "embedded"
          when "remote"
            raise "ERROR: Tgconfig - database driver field missing." if cfg['database']['driver'].nil?
            raise "ERROR: Tgconfig - database host field missing." if cfg['database']['host'].nil?
            raise "ERROR: Tgconfig - database name field missing." if cfg['database']['name'].nil?
            raise "ERROR: Tgconfig - database user field missing." if cfg['database']['user'].nil?
            raise "ERROR: Tgconfig - database pass field missing." if cfg['database']['pass'].nil?
          else
            raise "ERROR: Tgconfig - datbase configuration type is invalid."
        end #-> /case
      end #-> /Parse DB

      # => PARSE & CHECK: BBS Section
      if cfg['bbs'].nil?
        raise "ERROR: Tgconfig - bbs section not defined."
      else
        raise "ERROR: Tgconfig - bbs name field missing." if cfg['bbs']['name'].nil?
        raise "ERROR: Tgconfig - bbs tagline field missing." if cfg['bbs']['tagline'].nil?        
      end #-> /Parse BBS
    end #-> /if !Hash

    # => If all is well, return the configuration
    return cfg
  end #/def

end # => /module
