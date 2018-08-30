=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/tgio/dates.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Input Output for Dates
 TODO: * Date format is adjustable by config
 TODO: * Introduce Validation of Dates into this library

-----------------------------------------------------------------------------
=end


module Tgio
  module Dates
require 'date'

# Input a year
def Dates::inputyear
  tr = JLine::ConsoleReader.new
  char = nil
  enterkey = false
  input = []
  cursize = 0
  maxsize = 4
  vals = (48..57)
  print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"YYYY")
  print "\b" * 4
  until cursize == maxsize
    char = tr.readVirtualKey
    if vals.include?(char)
      input.push(char.chr)
      print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
      cursize +=1
    else
      print "\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"
    end #/if
  end #/until
  print ANSI_RESET
  value = ""
  input.each do |c|
    value.concat(c)
  end
  return value
end #/def inputyear

# Input a month
def Dates::inputmonth
  tr = JLine::ConsoleReader.new
  char = nil
  enterkey = false
  input = []
  cursize = 0
  maxsize = 2
  vals1 = (48..49) # Month first digit is either 0 or 1
  vals2 = (48..57) # Month second digit is 0 thru 9
  print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"MM")
  print "\b" * 2
  # TODO - Ensure val2 does not exceed 2 if val1 = 1
  until cursize == maxsize
    char = tr.readVirtualKey
    case cursize
      when 0
        if vals1.include?(char)
          input.push(char.chr)
          cursize +=1
          print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
        end #/if
      when 1
        if vals2.include?(char)
          input.push(char.chr)
          cursize +=1
          print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
        end #/if
    end
  end #/until
  print ANSI_RESET
  value = ""
  input.each do |c|
    value.concat(c)
  end
  return value
end #/def inputmonth

# Input a day
def Dates::inputday
  tr = JLine::ConsoleReader.new
  char = nil
  enterkey = false
  input = []
  cursize = 0
  maxsize = 2
  vals1 = (48..51) # Month first digit is either 0 or 1
  vals2 = (48..57) # Month second digit is 0 thru 9
  print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"MM")
  print "\b" * 2
  # TODO - Ensure val2 does not exceed 2 if val1 = 1
  until cursize == maxsize
    char = tr.readVirtualKey
    case cursize
      when 0
        if vals1.include?(char)
          input.push(char.chr)
          cursize +=1
          print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
        end #/if
      when 1
        if vals2.include?(char)
          input.push(char.chr)
          cursize +=1
          print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
        end #/if
    end
  end #/until
  print ANSI_RESET
  value = ""
  input.each do |c|
    value.concat(c)
  end
  return value
end #/def inputday


# Inputs a date
def Dates::inputdate
  #TODO: BUGFIX REQUIRED - Fix issue with backspacing during date input causing invalid entry.
  trap("INT") do
    # ignore "CTRL-C"
  end
  tr = JLine::ConsoleReader.new
  char = nil
  enterkey = false
  input = []
  cursize = 0
  print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"MM/DD/YYYY")
  print "\b" * 10
  month = self.inputmonth
  print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"/"
  day   = self.inputday
  print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"/"
  year  = self.inputyear
  print ANSI_RESET
  print "\n"
  value = Date.parse("#{year}-#{month}-#{day}")
  return value
end #/def inputdate

  end #/module
end #/module
