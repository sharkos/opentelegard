#!/usr/bin/env jruby
=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 

---[ File Info ]-------------------------------------------------------------

 Source File: /tg.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Main Runtime

-----------------------------------------------------------------------------
=end

# => Check if the program was called using the correct Ruby Interpreter
if RUBY_VERSION >= "2.5.0"
  unless defined? JRUBY_VERSION
    puts "OpenTelegard requires JRuby. Please visit ( http://www.jruby.org/ )."
    exit 255
  end
else
  puts "OpenTelegard requires JRuby interpreter compatible with Ruby '2.5.0' or later."
end


# => Prevent CTRL-C or SIGINT (2) Interrupt whilst running to prevent data corruption
# => We will want to handle this to perform a "CLEAN" shutdown.
Signal.trap("INT") do
  puts "CTRL-C (SIGINT) detected... ignoring"
  #exit 200
end

# => Prevent CTRL-Z or SIGTSTP (18) whilst running to prevent data corruption
# => We will want to handle this to perform a "CLEAN" shutdown.
Signal.trap("TSTP") do
end

# Deal with SIGHUP signal 1 from OS
Signal.trap("HUP") do
  puts "Ignoring HUP signal from OS."
end

# Handle SIGTERM signal 15 from OS
Signal.trap("TERM") do
  print "Termination signal received from OS..."
  Telegard.goodbye_fast
end


# Quit if the program runs as 'root'.
currentuser = `whoami`
if currentuser.chomp == "root"
puts "For security reasons, this program will not run as 'root' exiting..."
  exit 100
end

$LOAD_PATH.unshift('.')

# Detect Platform information and store into hash.
require 'java'
system        = java.lang.System
$jvminfo = {
'os_type'      => system.getProperty( 'os.name' ),
'os_arch'      => system.getProperty( 'os.arch'),
'os_vers'      => system.getProperty( 'os.version'),
'java_vend'    => system.getProperty( 'java.vendor'),
'java_vers'    => system.getProperty( 'java.version'),
'java_home'    => system.getProperty( 'java.home'),
'java_vm_vend' => system.getProperty( 'java.vm.vendor'),
'java_vm_vers' => system.getProperty( 'java.vm.version'),
'java_vm_name' => system.getProperty( 'java.vm.name'),
}


require 'optparse'
def getoptions(args)

	options = {}

	opts = OptionParser.new do |opts|
        opts.banner = "OpenTelegard/2 :: Copyright (c) 2008-2010, Chris Tusa.\nDistributed by LeafScale Systems, All rights reserved.\nUsage: "
        opts.separator ""

	opts.on("-g", "--genconfig", "Build sample configuration.") do |g|
		options[:genconfig] = g
	end

	opts.on("-l", "--login", "Perform Local Login to system.") do |l|
		options[:login] = l
    end

	opts.on("-v", "--version", "Print version and exit.") do |v|
		options[:version] = v
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
        # OLD = DISPLAY HELP
		#puts opts
        # NEW = LOGIN for tgshell?
        options[:login] = true
	end
  options
end	# end def

cmdswitch = getoptions(ARGV)

if cmdswitch.size > 1
  puts "note: #{$0} can only accept a single argument switch."
else
  # -> Switch: -g  :  Generate a sample config file
  if cmdswitch[:genconfig]
    sample = 'conf/telegard.conf.yaml.sample'
    unless File.exist?(sample)
      require "lib/tgconfig.rb"      
      Tgconfig.makedefault(sample)
      puts "Sample config created: #{sample}"
    else
      puts "File already exists, aborting."      
    end
  end

  if cmdswitch[:login]
    require 'lib/telegard'
    Telegard.init
    require 'lib/tglogin'
    Tgio::ansiclear
    validuser = Tglogin::auth
    if $session && validuser == true
      Tgtemplate::display('welcome.ftl')
      Tgtemplate::display('motd.ftl')
      MainController.new.menu

      # If we have reached this point, the main controller has exited.
      # Terminate the session in case nothing else has done so
      $session.destroy if $session
      $session = nil if $session
    end    
    exit 0
  end

  # -> Switch: -v  :  Display version number and exit immediatly.
  if cmdswitch[:version]
    require 'lib/tgconstants'
    puts TELEGARD_VERSION
    require 'pp'
    pp $jvminfo.inspect
    exit 0
  end
end

