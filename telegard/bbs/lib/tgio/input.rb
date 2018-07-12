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

 Source File: /lib/tgio/input.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Input Handler Library

-----------------------------------------------------------------------------
=end

=begin rdoc
= Input
Input provides routines to handle retrieving input from consoles.
=end

module Tgio
  module Input

    # Displays a colored input bar of length 2 and returns a value.
    # Works similar to inputform, except does not require the [ENTER] key.
    # Once user enters a valid value, returns immediately. If the / key
    # is entered as the first value, a second entry wil be permitted
    # but will return on the 2nd keypress.
    def Input::inputkey
      # ignore "CTRL-C"
      trap("INT") do
      end
      # initialize
      char = nil # Ensure char is set to nil
      done = false # Initialize the condition
      input = [] # Initialize the array of input chars
      cursize = 0 # Start the counter
      maxlength = 2 # Define the max length of the input box.
      print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" "*(maxlength-1))
      print "\b" * (maxlength-1)
      # Start loop until enter key is pressed
      until done == true
        print ANSI_RESET
        #char = STDIN.getc   # the Ruby Way (not so great)
        # Java JLine way
        char = JLine::ConsoleReader.new.readVirtualKey
        # handle [ENTER] key
        # If enter is pressed, then no value is returned.
        # The calling function will get an empty string or nil value.
        if char == 10 # [enter]
          input = [] # since nothing happens, turn input to an empty string
          #done = true
        elsif char == 127 # [backspace]
          #print "\b\b"+ANSI_BRIGHT_CYAN+ANSI_ON_BLUE+"   \b\b\b\b \b"
          print "\b\b"+ANSI_RESET+"  \b\b\b"
          print "\b\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"
          #input.pop                        #remove last type value
          #cursize -=1 unless cursize <= 0  #decrement cursize counter
          # handle everything else
        elsif char == 32 # [space]
          print "\b\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b\b"
        elsif char == 92 || char == 27 # [backslash] '\' or [esc]
          char = nil
        else
          if cursize < maxlength
            if char == 47 # the '/' key
              print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr.upcase
              cursize +=1
            else
              print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr.upcase
              cursize +=2
              done = true
            end
            input.push(char) #add new value
          else
            # if the size of the current input is > length, then drop the char
            print "\b \b"
            char = nil
          end
        end
        print ANSI_RESET
      end #/until
      # convert input array of character codes back into string
      value = ""
      input.each do |c|
        value.concat(c)
      end
      return value
    end

    #/def inputkey

    # Same as 'inputkey' method but for defaultpager
    def Input::pagerkey_default
      # ignore "CTRL-C"
      trap("INT") do
      end
      # initialize
      char = nil # Ensure char is set to nil
      done = false # Initialize the condition
      input = [] # Initialize the array of input chars
      cursize = 0 # Start the counter
      maxlength = 1 # Define the max length of the input box.
      print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" "*(maxlength))
      print "\b" * (maxlength)
      # Start loop until enter key is pressed
      until done == true
        print ANSI_RESET
        #char = STDIN.getc   # the Ruby Way (not so great)
        # Java JLine way
        char = JLine::ConsoleReader.new.readVirtualKey
        # handle [ENTER] key
        # If enter is pressed, then no value is returned.
        # The calling function will get an empty string or nil value.
        if char == 10 # [enter]
          input = [] # since nothing happens, turn input to an empty string
          done = true
          return 'Y'
        elsif char == 127 # [backspace]
          #print "\b\b"+ANSI_BRIGHT_CYAN+ANSI_ON_BLUE+"   \b\b\b\b \b"
          print "\b\b"+ANSI_RESET+"  \b\b\b"
          print "\b\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"
          #input.pop                        #remove last type value
          #cursize -=1 unless cursize <= 0  #decrement cursize counter
          # handle everything else
        elsif char == 32 # [space]
          print "\b\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b\b"
        elsif char == 92 || char == 27 # [backslash] '\' or [esc]
          char = nil
        else
          if cursize < maxlength
            print "\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
            input.push(char) #add new value
            cursize +=2
            done = true

          else
            # if the size of the current input is > length, then drop the char
            print "\b \b"
            char = nil
          end
        end
        print ANSI_RESET
      end #/until
      # convert input array of character codes back into string
      value = ""
      input.each do |c|
        value.concat(c)
      end
      return value
    end

    #/def pagerkey

    # Displays a colored input bar of specified length and returns a value. This
    # may sound simple, but in order to provide more precise input control,
    # the input is read character by character into an array. The array is
    # a set of numbers which represent the character code. Before returning
    # the value, it is converted to a string. (replaces ansigets)
    def Input::inputform(length)
      trap("INT") do
        # ignore "CTRL-C"
      end
      tr = JLine::ConsoleReader.new
      char = nil
      enterkey = false
      input = []
      cursize = 0
      print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" "*length)
      print "\b" * length
      # initialize
      # Start loop until enter key is pressed
      until enterkey == true
        #print ANSI_RESET
        char = tr.readVirtualKey
        # handle [ENTER] key
        if char == 10
          enterkey = true
        else
          # handle [Backspace] key
          if char == 8
            unless cursize == 0
              print "\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"
              input.pop #remove last type value
              cursize -=1 unless cursize <= 0 #decrement cursize counter
            end
            # handle everything else
          else
            if cursize < length
              print ""+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
              input.push(char) #add new value
              cursize += 1 #increment cursize counter
            else
              # if the size of the current input is > length, then drop the char
              print "\b \b"
              char = nil
            end
          end
        end
        print ANSI_RESET
      end
      # convert input array of character codes back into string
      print ANSI_ON_BLUE+(" "*input.size)+ANSI_RESET+"\n"
      value = ""
      input.each do |c|
        value.concat(c)
      end
      return value
    end

    #/def inputform


    # Login Prompt
    def Input::loginform
      trap("INT") do
        # ignore "CTRL-C"
        Telegard.goodbye
      end
      tr = JLine::ConsoleReader.new
      char = nil
      enterkey = false
      input = []
      cursize = 0
      length = 16
      print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" "*length)
      print "\b" * length
      # initialize
      # Start loop until enter key is pressed
      until enterkey == true
        #print ANSI_RESET
        char = tr.readVirtualKey
        # handle [ENTER] key
        if char == 10
          enterkey = true
        else
          # handle [Backspace] key
          if char == 8
            unless cursize == 0
              print "\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"
              input.pop #remove last type value
              cursize -=1 unless cursize <= 0 #decrement cursize counter
            end
            # handle everything else
          else
            if cursize < length
              print ""+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr.upcase
              input.push(char) #add new value
              cursize += 1 #increment cursize counter
            else
              # if the size of the current input is > length, then drop the char
              print "\b \b"
              char = nil
            end
          end
        end
        print ANSI_RESET
      end
      # convert input array of character codes back into string
      value = ""
      input.each do |c|
        value.concat(c)
      end
      print ANSI_RESET+"\n"
      return value.upcase
    end

    #/def loginform


    # Password Prompt character reader. Replaces input with % for output.
    def Input::passwordform
      trap("INT") do
        # ignore "CTRL-C"
      end
      tr = JLine::ConsoleReader.new
      char = nil
      enterkey = false
      input = []
      cursize = 0
      length = 25
      print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" "*length)
      print "\b" * length
      # initialize
      # Start loop until enter key is pressed
      until enterkey == true
        #print ANSI_RESET
        char = tr.readVirtualKey
        # handle [ENTER] key
        if char == 10
          enterkey = true
        else
          # handle [Backspace] key
          if char == 8
            # TODO: bugfix - minor visual issue where additional 3 spaces
            # are added to end of a line when backspace occurs after a certain
            # point during the inputform.
            unless cursize == 0
              print "\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"
              input.pop #remove last type value
              cursize -=1 unless cursize <= 0 #decrement cursize counter
            end
            # handle everything else
          else
            if cursize < length
              print ""+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"%"
              input.push(char) #add new value
              cursize += 1 #increment cursize counter
            else
              # if the size of the current input is > length, then drop the char
              print "\b \b"
              char = nil
            end
          end
        end
        print ANSI_RESET
      end
      # convert input array of character codes back into string
      value = ""
      input.each do |c|
        value.concat(c)
      end
      print "\n"
      return value
    end

    #/def passwordform


# Displays a colored input bar of length 1 and returns a boolean based
# on a yes/no question. Only valid characters are Y & N.
    def Input::inputyn(template=nil)
      # ignore "CTRL-C"
      trap("INT") do
      end

      unless template.nil? == true
        t = Tgtemplate::Template.new(template)
        t.render()
      end

      # initialize
      char = nil # Ensure char is set to nil
      done = false # Initialize the condition
      input = [] # Initialize the array of input chars
      cursize = 0 # Start the counter
      maxlength = 1 # Define the max length of the input box.
      print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" "*(maxlength))
      print "\b" * (maxlength)
      # Start loop until enter key is pressed
      until done == true
        print ANSI_RESET
        char = JLine::ConsoleReader.new.readVirtualKey
        unless char == 8
          case char.chr.upcase
            when "Y"
              value = true
              done = true
            when "N"
              value = false
              done = true
            else
              #print "\b" * (maxlength)
              #print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"*(maxlength))
          end #/case
        end #/unless
      end #/until
      print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr.upcase+ANSI_RESET+"\n"
      return value
    end

    #/def inputyn

# Displays a colored input bar of length 1 and returns a boolean based
# on a yes/no question. Only valid characters are M & F.
    def Input::inputgender(template=nil)
      # ignore "CTRL-C"
      trap("INT") do
      end
      unless template.nil? == true
        t = Tgtemplate::Template.new(template)
        t.render()
      end
      # initialize
      char = nil # Ensure char is set to nil
      done = false # Initialize the condition
      input = [] # Initialize the array of input chars
      cursize = 0 # Start the counter
      maxlength = 1 # Define the max length of the input box.
      print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" "*(maxlength))
      print "\b" * (maxlength)
      # Start loop until enter key is pressed
      until done == true
        print ANSI_RESET
        char = JLine::ConsoleReader.new.readVirtualKey
        unless char == 8
          case char.chr.upcase
            when "M"
              value = "M"
              done = true
            when "F"
              value = "F"
              done = true
            else
              #print "\b" * (maxlength)
              #print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"*(maxlength))
          end #/case
        end #/unless
      end #/until
      print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr.upcase+ANSI_RESET+"\n"
      return value
    end
    #/def inputgender


    # Menu Prompt: Recieve input restricted to a list of validkeys
    def Input::menuprompt(template, validkeys, menudata=nil)
      trap("INT") do
      end
      # Append globalkeys to supplied validkeys array. This is for DRY within each menu prompt.
      globalkeys = ['/?', '/G', '/H', '/M', '/P', '/T', '/W']
      validkeys = validkeys.concat(globalkeys)
      # Initialize loop condition
      done = false
      until done == true
        # Display menu template only if user preference is True
        if $session.nil? == false
          if $session.pref_show_menus == true
            Tgtemplate::display(template, menudata)
          end
        elsif $session.nil? == true
          Tgtemplate::display(template, menudata)
        end

        # Display the prompt
        Tgtemplate::display('menu_prompt.ftl')
        selection = self.inputkey.upcase
        # Check if user supplied selection is included in validkeys array
        if validkeys.include?(selection)
          # Check for Global Input Values with prepended slash
          case selection
            when "/?" # Show the shortcut / commands menu
              Tgtemplate::display('menu_shortcuts.ftl')
            when "/G" # Fast Goodybye
              Telegard::goodbye_fast
              return 0
            when "/H" # Help Menu - probably dont want this here
              Telegard.unimplemented
            when "/M" # Toggle $session.prefs_show_menus
              $session.pref_show_menus = $session.pref_show_menus.toggle
              $session.save
              Tgtemplate::display('toggle_show_menus.ftl', {"togglevalue" => $session.pref_show_menus.to_s})
            when "/P" # Toggle $session.prefs_term_pager
              $session.pref_term_pager = $session.pref_term_pager.toggle
              $session.save
              Tgtemplate::display('toggle_term_pager.ftl', {"togglevalue" => $session.pref_term_pager.to_s})
            when "/T" # Show time remaining
              Tgtemplate::display('time_remain.ftl', {
                      'timeremain'=> $session.timeremain.to_s,
                      'curtime' => Time.now.to_s,
                      'expires' => $session.expires.to_s
              })
            when "/W"
              puts "Who's online"
            when "/X"
              puts "Fast Return to Main"
          end
          done = true
        else
          Tgtemplate::display('menu_invalidkey.ftl')
        end
      end
      return selection
    end


    # Same as inputform except supports line wrapping for use in Editor
    def Input::inputeditline(length=79)
      trap("INT") do
        # ignore "CTRL-C"
      end
      tr = JLine::ConsoleReader.new
      char = nil
      enterkey = false
      input = []
      cursize = 0
      print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" "*length)
      print "\b" * length
      # initialize
      # Start loop until enter key is pressed
      until enterkey == true
        #print ANSI_RESET
        char = tr.readVirtualKey
        # handle [ENTER] key
        if char == 10
          enterkey = true
          print "\n"
        else
          # handle [Backspace] key
          if char == 8
            unless cursize == 0
              print "\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"
              input.pop #remove last type value
              cursize -=1 unless cursize <= 0 #decrement cursize counter
            end
            # handle everything else
          else
            if cursize < (length - 1)
              print ""+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
              input.push(char) #add new value
              cursize += 1 #increment cursize counter
            else
              # if the size of the current input is >= length, then goto next line.
              print ""+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
              input.push(char)
              enterkey = true
              print ANSI_RESET+"\n"
              #char = nil
            end
          end
        end
        print ANSI_RESET
      end
      # convert input array of character codes back into string
      #print ANSI_ON_BLUE+(" "*input.size)+ANSI_RESET+"\n"
      value = ""
      input.each do |c|
        value.concat(c)
      end
      return value
    end #/def inputeditline


  end #/end module
end #/end module