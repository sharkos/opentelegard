#!/usr/bin/env ruby
# 
=begin
                ===============================================
                              OpenTG BBS Project
                        Copyright (C) 2009  Chris Tusa
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

 Source File: tglogin.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Login/Logout Functions


---[ Changelog ]-------------------------------------------------------------


---[ TODO Items ]------------------------------------------------------------
 

=end
#
# ---[ Program Code Begins ]-------------------------------------------------


##--------------------------------------------------------------##
# Loginshell class - handles all aspects of login until logout   #
#  This could be considered the main control function that will
#  handle the passing around of menus and features. 
#  In this routine, try to avoid doing anything manual, such as
#  a database call. Try to offload to other classes and functions
#
##--------------------------------------------------------------##
class Loginshell

 attr_accessor :ttynum, :callnumber

def initialize
	cfg = TGconfig.new
	@cfgin = cfg.load
end

def start
 begin
  unless @cfgin.bbs_enabled == false
	# Start at LOGIN prompt
	self.login


	# stuff in the middle here
	self.mainmenu

	# Finish at LOGOUT 
	self.logout
  else
	puts "#{@cfgin.bbs_name} is currently offline. Try again later."
  end
 ensure
  #TODO: Update login time.
  exit 0
 end

end


def login
 # do actual login

	@node = "none"
	# Print a welcome graphic
	printansifile("#{@cfgin.path_ansi}/login.ans")
	authprog=User.new
	permsprog=Permissions.new
	@userdata = authprog.login
	if @userdata == nil
		return 1
	end

	#TODO: Check if user is already logged in on another node

	@userperms = permsprog.loadperms(@userdata['uid'])
 
	if @userperms.allowlogin == false
		ansiputs("Permission Denied: You are not allowed to login!\n",red)
		return 1
	end


	@logintime = Time.now
	#TODO: update CallHistory here
	historyprog = CallHistory.new
	historydata = { "login" => @userdata['login'].upcase, "node" => @node, "timeon" => @logintime, 
"timeoff" => nil, "city" => @userdata['city'], "state" => @userdata['state'] }
	@callnumber = historyprog.add(historydata)

	# Start less fork
#	run_pager

	# send text welcome
	ansiputs("\nWelcome, ", white)
	ansiputs("#{@userdata['login'].upcase}", yellow)
	ansiputs(", to ", white)
	ansiputs("#{@cfgin.bbs_name} ", cyan)
	ansiputs("(", blue, false)
	ansiputs("#{@cfgin.bbs_city},#{@cfgin.bbs_state} - #{@cfgin.bbs_country}",blue)
	ansiputs(")\n", blue, false)

	ansiputs("You are caller #", white)
	ansiputs("#{@callnumber}\n", yellow)
	ansiputs("The current BBS Time is now: #{@logintime}\n", white)

	#TODO: convert time format - see tgrubyext.rb - maybe extend Time class to handle dbi conversion
	ansiputs("\nYour last login was: #{@userdata['lastlogin']}\n", white) unless @userdata['lastlogin'].nil?

	# Check for user failed attempts and report
	numfailed = @userdata['loginfailed'].to_i 
	if numfailed > 0
		ansiputs("\n** There have been ",red)
 		ansiputs("#{numfailed} ",yellow)
		ansiputs("failed login attempts **\n", red)
		#TODO: Ask user if they want to change their pw now.

		# Since user is logged in OK now, clear failed login counter
		authprog.clearfails(@userdata['uid'])
	end

	# Check if the user's password has expired
	pwexpires = convertdate(@userdata['pwexpires'])
	if @logintime >= pwexpires
		ansiputs("\n** Your password has expired and must be changed **\n", red)
		authprog.resetpw(@userdata['uid'])
	end

	# show caller history
	historyprog.show(@cfgin.recent_min)

	print "\n\n"
	printansifile("#{@cfgin.path_ansi}/motd.ans")
	print "\n\n"
	return 0
end


def logout
 # cleanup for logout
	historyprog = CallHistory.new
	timeoff = historyprog.update(@callnumber)

	ansiputs("Caller #",white)
	ansiputs("#{@callnumber}\s", yellow)
	ansiputs("logout @ #{timeoff}\n", white)

	ansiputs("You have been logged out...\n\n", red, false)
 return 0 
end

# Main Starting Point
def mainmenu

menuloop = 1
while menuloop > 0

 ansiputs("\t\t\t--=] ",cyan,false)
 ansiputs("Main Menu", blue)
 ansiputs(" [=--\n\n", cyan, false)

 print "\t"
 ansimenu("B", "BS information", "\t")
 ansimenu("C", "hat Menu", "\t")
 ansimenu("F", "ile Areas", "\n")

 print "\t"
 ansimenu("G", "oodbye/Logout", "\t")
 ansimenu("L", "ist of BBS'", "\t")
 ansimenu("M", "sgs Areas", "\n")

 print "\t"
 ansimenu("P", "age Sysop", "\t\t")
 ansimenu("T", "imebank", "\t")
 ansimenu("U", "sers Menu", "\n")

 print "\n"
 ansiputs("(",blue, false)
 ansiputs("Time: ",blue)
 ansiputs("00:00",cyan)
 ansiputs(")\n",blue, false)
 ansiputs("Select: ", blue, false)

	mmselect = ansigets(2)
	case mmselect
		when 'G', 'g'
			menuloop = 0
      when 'B', 'b'
         TGbbsinfo.new.out

	end # end case
end # end while

end # end def mainmenu


end # END Loginshell class