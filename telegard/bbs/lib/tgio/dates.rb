=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
                  Copyright (C) 2010, LeafScale Systems, LLC
                            http://www.opentg.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2010, Chris Tusa & LeafScale Systems, LLC
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

 Source File: /lib/tgio/date.rb
     Version: 0.01
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