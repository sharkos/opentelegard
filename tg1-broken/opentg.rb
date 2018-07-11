#!/usr/bin/env ruby
# 
=begin
                ===============================================
                              OpenTG BBS Project
                     Copyright (C) 2008 - 2009  Chris Tusa
                http://www.opentg.org | telnet://bbs.opentg.org
                ===============================================


---[ License & Distribution ]------------------------------------------------

OpenTG is distributed under the GNU General Public License version 3 (GPLv3)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


---[ File Info ]-------------------------------------------------------------

 Source File: opentg.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Main execution code


---[ Changelog ]-------------------------------------------------------------

 * 20090312 Adapted from ALPS code as a structural template

---[ TODO Items ]------------------------------------------------------------
 
 * Incorporate ANSI colors
 * As things grow, break out into modules.
 * Revisit NCurses Menuing System and cleanup code for more friendly style.

=end
#
# ---[ Program Code Begins ]-------------------------------------------------


require 'tgincludes.rb'


##--------------------------------------------------------------##
# Execution routines - pre-requisites for entire program run     #
##--------------------------------------------------------------##
class Execute

	attr_accessor	:distrotype, :level, :releasefile, :release,
						:osfingerprint, :ostype, :osvendor, :osversion

def start
end

def detectos
	# OS release file fingerprints:
	# CentOS release 5.2 (Final)
	# Red Hat Enterprise Linux ES release 4 (Nahant Update 7)
	# Red Hat Enterprise Linux Server release 5.2 (Tikanga)
	# Fedora release 9 (Sulphur)
	# Fedora release 10 (Cambridge)
	   # Notes: (ArchLinux does not have a populated release file)
		#  Fedora & CentOS still store their release info in redhat-release,
		#  until this changes, no need to consider these separatly. 
		#  Debian & SharkOS support not yet written, but we can detect anyway.
		releasefile = {
			'rhcompat'	=> '/etc/redhat-release',
			'arch' 		=> '/etc/arch-release',
			'debcompat' => '/etc/debian_version',
			'suse'		=> '/etc/SuSE-release',
			'sharkos'	=> '/etc/sharkos-release'
		}

		releasefile.each do |distro, filename|
			if File.exists?(filename)
				f = File.open(filename)
				@release = f.gets
				@distrotype = distro
			end
		end # end DO loop

		case @distrotype
			when "rhcompat"
				if @release.match("Red Hat Enterprise Linux")
					@osvendor = "RHEL"
					@osversion = @release.scan(/\d+/)
					revnum = @release.scan(/\d+/)
					if revnum.length > 1
						@osversion = revnum.join('.').to_f
					else 
						@osversion = revnum.to_f
					end
					if @osversion < 5
						@osrepotype = "up2date"
					else
						@osrepotype = "yum"
					end
				end
				if @release.match("CentOS release")
					@osvendor = "CentOS"
					revnum = @release.scan(/\d+/)
					if revnum.length > 1
						@osversion = revnum.join('.').to_f
					else
						@osversion = revnum.to_f
					end
					@osrepotype = "yum"
				end
				if @release.match("Fedora release")
					@osvendor = "Fedora"
					@osversion = @release.scan(/\d+/)[0].to_f
					@osrepotype = "yum"
				end

			when "arch"
				@osvendor = "ArchLinux"
				@osversion = 0.0	# Arch uses year.month format for release.
				@osrepotype = "pacman"
			when "sharkos"
				@osvendor = "SharkOS"
				@osversion = 0.0
				@osrepotype = "pacman"
			when "debian"
				@osvendor = "Debian"
				@osversion = 0.0
				@osrepotype = "apt"
			else
				@osvendor = "Unknown"
				@osversion = 0.0
				@osrepotype = "unsupported"
		end
		osfingerprint = { "osvendor" => @osvendor, "osversion" => @osversion, "repotype" => @osrepotype }
	return osfingerprint
end # end detectos

def finish(level)
		@level = level
#		lockfile = Lockfile.new
#		lockfile.delete
		exit @level
end

##--------------------------------------------------------------##
# Options parser function (uses OptionParse.rb library)	        #
##--------------------------------------------------------------##
def getoptions(args)
	options = {}
# Display Program Banner


HighLine.color_scheme = Tgcolors01
say("<%= color('#{TGversion['shortname']}', :title) %> <%= color(':', :bracket) %> <%= color('#{TGversion['longname']} v#{TGversion['version']}', :text) %> <%= color('(', :bracket) %> <%= color('Ruby v#{RUBY_VERSION}', :text) %> <%= color(')', :bracket) %> <%= color('-', :bracket) %> <%= color('Released under #{TGversion['license']}', :title) %>\n<%= color('#{TGversion['copyright']} #{TGversion['author']} - #{TGversion['vendor']}', :title)%>\n\n")


# NON ANSI COLORED OUTPUT
#puts "#{TGversion['shortname']} : #{TGversion['longname']} v#{TGversion['version']} (Ruby v#{RUBY_VERSION}) - Released under #{TGversion['license']}\n#{TGversion['copyright']} #{TGversion['author']} - #{TGversion['vendor']}\n\n"

	opts = OptionParser.new do |opts|
        opts.banner = "Usage: #{TGversion['shortname']} [options]"
        opts.separator ""
        opts.separator "Specific options:"

	opts.on("-a", "--showansi", "Show Ansi Colors") do |a|
		options[:ansi] = a
	end
	opts.on("-c", "--config", "Build or Edit the configuration.") do |c|
		options[:config] = c 
	end
	opts.on("-l", "--login", "Login to system.") do |l|
		options[:login] = l
	end
	opts.on("-s", "--showuser", "Show a user or users") do |l|
		options[:showuser] = l
	end
	opts.on("-t", "--crontab", "Generate a fresh crontab.") do |t|
	 	options[:crontab] = t
	end
	opts.on("-u", "--update", "Check for & Perform Update.") do |u| 
		options[:update] = u
	end
	opts.on("-g", "--upgrade", "Upgrade config file to latest revision.") do |g| 
		options[:upgrade] = g
	end
	opts.on("-v", "--version" "Print version and exit.") do |v|
		options[:version] = v
	end
	opts.on("-w", "--who", "WFC Style Screen (who is online monitoring)") do |w|
		options[:who] = w
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
	if options.empty? == true
		puts opts
#		options[:login] = true
	end
  options
end	# end def

end # end class





##--------------------------------------------------------------##
# MAIN PROGRAM EXECUTION - Checks, Parses & Passes to subroutine #
##--------------------------------------------------------------##


trap("INT") do
# puts "CTRL-C Called - Handle this later" 
# exit 255
end
# See if we are running as root, otherwise quit.
currentuser = `whoami`
# if currentuser.chomp == "root"
#	puts "This program cannot be run as root."
#	exit 1
# end


## Parse command switches
##
## Note: this may not be the cleanest way to accomplish this.
##			In the interest of time, get it done, and recode later.
##


# Break out of command parsing to do some startup items
mainprog = Execute.new
cmdswitches = mainprog.getoptions(ARGV)
case cmdswitches[:verbose]
	when true
		Verbosemode = true
   else
		Verbosemode = false
#	puts "Verbose output enabled."
end

mainprog.start
osfingerprint = mainprog.detectos



# Continue parsing switches

case cmdswitches[:debug]
	when true
	Debug = on
end

case cmdswitches[:config]
	when true
	configprog = TGconfig.new
	# check if config file exists 0 = yes, 1= no
	if configprog.check == 0
		configprog.edit
	else
		configprog.build(osfingerprint)
   end
	mainprog.finish(0)
end

case cmdswitches[:update]
	when true
	updateprog = Updater.new
	updateprog.start(osfingerprint, cmdswitches[:manual])
	mainprog.finish(0)
end

case cmdswitches[:login]
	when true
	loginprog = Loginshell.new
	code = loginprog.start
	mainprog.finish(code)
end

case cmdswitches[:upgrade]
	when true
 	upgradeprog = TGconfig.new
 	upgradeprog.upgrade
	mainprog.finish(0)
end

case cmdswitches[:version]
	when true
	puts osfingerprint.inspect
	mainprog.finish(0)
end

case cmdswitches[:crontab]
	when true
	crontabprog = Crontab.new
	crontabprog.start
	mainprog.finish(0)
end

case cmdswitches[:ansi]
	when true
# Using this option for other function testing.
#	ansicolorlist
	testprog = User.new
#	testprog.show("all")
	testprog.login
	mainprog.finish(0)
end

# Exit clean if we get to this point. 
# This is failsafe in case we forgot to cleanup elsewhere
mainprog.finish(0)
#@EOL