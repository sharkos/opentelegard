#!/usr/bin/env ruby
# 
=begin
                ===============================================
                              OpenTG BBS Project
                        Copyright (C) 2008  Chris Tusa
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

 Source File: tgoutput.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: OpenTG output functions for screen & logs


---[ Changelog ]-------------------------------------------------------------


---[ TODO Items ]------------------------------------------------------------
 

=end
#
# ---[ Program Code Begins ]-------------------------------------------------


# Define Global Color Schemes 

# Color scheme for displaying version coloring
Tgcolors01 = HighLine::ColorScheme.new do |cs|
         cs[:title]		= [ :bold, :blue, :on_black ]
         cs[:bracket]	= [ :blue, :on_black ]
         cs[:text]		= [ :bold, :cyan, :on_black ]
         cs[:item]		= [ :bold, :yellow, :on_black ]
       end

# Color scheme for displaying input forms
Tgcolors02 = HighLine::ColorScheme.new do |cs|
		   cs[:prompt]		= [ :bold, :blue, :on_black ]
         cs[:echo]		= [ :bold, :cyan, :on_blue ]
         cs[:error]		= [ :bold, :red, :on_black ]
         cs[:warning]	= [ :bold, :yellow, :on_black ]
         cs[:normal]	= [ :white, :on_black ]
       end


## Log File Settings
Logdir = "/var/log/opentg"
Masterlog = "#{Logdir}/opentg.log"
Logrotatekeep = 4				# Keep number of historical logs, expressed as integer
Logrotatesize = 26214400 	# (25MB) value in bytes, expressed as longint



##--------------------------------------------------------------##
# bout - Better output - Combine's logging, verbose mode, & std  #
##--------------------------------------------------------------##
#
# example: "bout(Updaterlog, 1, "Normal output", "Verbose Output")
# loglevel 
#  0 - debug
#  1 - info
#  2 - warn
#  3 - error
#  4 - fatal
#
# To not display one of the messages, use 'nil' as its value.

def bout(logfile, loglevel, msg, verbosemsg)
	logpath="#{Logdir}"
	if File.exists?(logpath) && File.directory?(logpath)
	else
			Dir.mkdir(logpath, 0655)
			bout(Masterlog, 1, nil, "Log: Created directory #{Logdir}")
	end
	logger = Logger.new(logfile, Logrotatekeep, Logrotatesize)
	puts msg unless msg.nil?
	logger.info msg unless msg.nil?
	case loglevel.to_i
		when 0
			logger.debug msg
		when 1
			logger.info msg
		when 2
			logger.warn msg
		when 3
			logger.error msg
		when 4
			logger.fatal msg
		else
			puts "log level incorrectly specified in function bout"
	end
	if Verbosemode == true
		puts verbosemsg unless verbosemsg.nil?
		logger.debug verbosemsg unless verbosemsg.nil?
	end
	logger.close
end


##--------------------------------------------------------------##
# lout - simplified log output                                   #
##--------------------------------------------------------------##
#
# Similar to bout, except only write things to log messages.
# ex: lout(Updaterlog, 1, "Some Log Message")
#
def lout(logfile, loglevel, logmsg)
	logpath="#{Logdir}"
	if File.exists?(logpath) && File.directory?(logpath)
	else
			Dir.mkdir(logpath, 0655)
			bout(Masterlog, 1, nil, "Log: Created directory #{Logdir}")
	end
	logger = Logger.new(logfile, Logrotatekeep, Logrotatesize)
	logger.info logmsg unless logmsg.nil?
	case loglevel.to_i
		when 0
			logger.debug logmsg
		when 1
			logger.info logmsg
		when 2
			logger.warn logmsg
		when 3
			logger.error logmsg
		when 4
			logger.fatal logmsg
		else
			puts "log level incorrectly specified in function lout"
	end		
	logger.close
end


##--------------------------------------------------------------##
# Get input from an ANSI color block                             #
##--------------------------------------------------------------##
def ansigets(length)
# TODO: Limit the input by the length size
	print clear, reset, ""
	inputblock = " " * length
	print cyan, bold, on_blue, "#{inputblock}" 
	print "\b" * length, reset

#BUG: There is a known bug that when using a fill background color, the 
#carriage return of the input field carries onto the next line and skews
#the screen coloring from intended. Therefore, the color field box will be
#displayed, but until a workaround is found, input from STDIN will be on a
#on_black bgcolor
#  	print cyan, bold, on_blue, "" 
#	   userinput = scanf("%s")

  	print white, bold, on_black, "" 
	userinput = gets.chomp

	print clear, reset, ""
	userinput.to_s
end

##--------------------------------------------------------------##
# Print Output in a ANSI color block                             #
##--------------------------------------------------------------##
def ansiputs(text, fgcolor, bolded=true)
	if bolded == true
	print fgcolor, on_black, bold, text
	else
	print fgcolor, on_black,  text
	end
	print clear, reset, ""
end

##--------------------------------------------------------------##
# Print Output in a ANSI color block for menus                   #
##--------------------------------------------------------------##
def ansimenu(key, descr, handler)
	print blue, on_black, "("
	print magenta, on_black, bold, key, reset
	print blue, on_black, ")"
	print blue, on_black, bold, descr
	print clear,reset, handler 
end


##--------------------------------------------------------------##
# The desired effect is to clear the screen                      #
##--------------------------------------------------------------##
def ansiclear
	print clear, reset, ""
end


##--------------------------------------------------------------##
# Demonstrate how to use Ansi Colors                             #
##--------------------------------------------------------------##
def ansicolorlist

 include Term::ANSIColor
  
 print red { bold { "Usage as block forms:" } }, "\n"
 print clear { "clear" }, reset { "reset" }, bold { "bold" },
   dark { "dark" }, underscore { "underscore" }, blink { "blink" },
   negative { "negative" }, concealed { "concealed" }, "|\n",
   black { "black" }, red { "red" }, green { "green" },
   yellow { "yellow" }, blue { "blue" }, magenta { "magenta" },
   cyan { "cyan" }, white { "white" }, "|\n",
   on_black { "on_black" }, on_red { "on_red" }, on_green { "on_green" },
   on_yellow { "on_yellow" }, on_blue { "on_blue" },
   on_magenta { "on_magenta" }, on_cyan { "on_cyan" },
   on_white { "on_white" }, "|\n\n"

symbols = Term::ANSIColor::attributes
 print red { bold { "All supported attributes = " } },
   blue { symbols.inspect }, "\n\n"
end

def printansifile(filename, paging=true, numlines=25)
#	puts "DEBUG: Attempting to print ANSI file: #{filename}"

#TODO: Add Paging feature to limit number of lines with more prompt
 if File.exist?(filename)
  File.open(filename, "r").each { |line| puts line }
 else
  return 1
 end
end

# 
def pause
   prompt = ":[next]: "
   d = ask(prompt, true) { |q| 
            q.limit = 1
             q.echo = false }

end

# DATE CONVERSION FROM DATABASE STRING TO TIME CLASS
def convertdate(dbvalue)
	d = dbvalue.to_s.split("-")
	dyear = d[0]
	dmonth = d[1]
	dday = d[2]
	dateout = Time.utc(dyear, dmonth, dday)
end



# Paging Function to incorporate scrolling into program
# adapted from code written by : Nathan Weizenbaum
# http://nex-3.com/posts/73-git-style-automatic-paging-in-ruby
def run_pager
  return unless STDOUT.tty?

  read, write = IO.pipe

  unless Kernel.fork # Child process
    STDOUT.reopen(write)
    STDERR.reopen(write) if STDERR.tty?
    read.close
    write.close
    return
  end

  # Parent process, become pager
  STDIN.reopen(read)
  read.close
  write.close

  ENV['LESS'] = '-FSRX' # Don't page if the input is short enough
  ENV['LESSSECURE'] = '1' # Turn on secure less (see man page)

  Kernel.select [STDIN] # Wait until we have input before we start the pager
  pager = ENV['PAGER'] || 'less'

  exec pager rescue exec "/bin/sh", "-c", pager
end

