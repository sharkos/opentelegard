#!/usr/bin/env jruby
=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011,  LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2008-2011, Chris Tusa & LeafScale Systems, LLC
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

 Source File: /tg.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Main Runtime

-----------------------------------------------------------------------------
=end

# => Check if the program was called using the correct Ruby Interpreter
unless JRUBY_VERSION.nil?
  if RUBY_VERSION < "1.8.7"
    puts "OpenTelegard requires version 1.8.7 or later compatible Ruby."
  end
else
  puts "OpenTelegard requires JRuby. Please visit ( http://www.jruby.org/ )."
  exit 255
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


# See if we are running as root, otherwise quit.
currentuser = `whoami`
if currentuser.chomp == "root"
puts "This program should not be run as 'root' for security reasons, exiting."
  exit 100
end

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
      require 'lib/tgconfig'      
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

