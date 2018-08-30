=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/tgio.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Input Output Handlers

-----------------------------------------------------------------------------
=end

require 'rubygems'
require 'lib/tgio/input'
require 'lib/tgio/output'
require 'lib/tgio/dates'
require 'lib/tgio/tgedit'

=begin rdoc               
= Tgio (I/O)
Tgio provides the common input/output routines for dealing with STDOUT and STDIN. This includes the ANSI color output methods, pauses, screenclear, etc.
=end


module Tgio

  # Print Output in a ANSI color block using Term::ANSIColor
  # (DEPRECATED)
  def Tgio::ansiprint(text, fgcolor=ANSI_WHITE, bgcolor=ANSI_ON_BLACK)
      print fgcolor+bgcolor+text+ANSI_RESET
  end #/ansiprint

  # AUDIT CODE: REPLACE WITH NEW TG COLORS
  # Display the program's MAIN banner
  def Tgio.mainbanner
    ansiprint("OpenTelegard", ANSI_BRIGHT_CYAN)
    ansiprint(" v", ANSI_CYAN)
    ansiprint(TELEGARD_VERSION, ANSI_BRIGHT_CYAN)
    ansiprint(" :: ", ANSI_BLUE)
    ansiprint("Copyright (c) 2008-2011, Chris Tusa\n", ANSI_BRIGHT_CYAN)
    ansiprint("All rights reserved.\n", ANSI_CYAN)
    ansiprint("Distributed by LeafScale Systems - see the LICENSE file.\n\n", ANSI_DARK_GRAY)
  end #/def mainbanner



  # The desired effect is to clear the screen
  def Tgio::ansiclear
    JLine::ConsoleReader.new.clearScreen
  end #/def ansiclear

  # Print an ANSI graphic file (legacy - see Tgtemplate)
  def Tgio.printansifile(filename, paging=true, numlines=25)
    # =>TODO: Add Paging feature to limit number of lines with more prompt
    
    if File.exist?(filename)
      File.open(filename, "r").each { |line| puts line }
    else
      return 1
    end
  end #/def printansifile

  # Print to stdout that an item is starting
  def Tgio.printstart(txt)
    ansiprint(txt, ANSI_WHITE)
    ansiprint("."*(60-txt.length), ANSI_GRAY)
  end #/def printstart

  # Print to stdout the result
  def Tgio.printreturn(retval)
    ansiprint("[", ANSI_BLUE)
    if retval == 0
      ansiprint("DONE", ANSI_BRIGHT_CYAN)
    elsif retval == 1
      ansiprint("FAIL", ANSI_BRIGHT_RED)
    elsif retval == 2
      ansiprint("WAIT", ANSI_CYAN)
    else
      ansiprint("????", ANSI_BRIGHT_MAGENTA)
    end
    ansiprint("]\n", ANSI_BLUE)
  end #/def printreturn

  # Paging Function to incorporate scrolling into program  
  # adapted from code written by : Nathan Weizenbaum
  # http://nex-3.com/posts/73-git-style-automatic-paging-in-ruby
  # * WARN * Allowing execution of an external program is not good security
  # practices. Audit this for a better method.
  def Tgio.run_pager
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
  end #/def run_pager



  # Terminal detection to determine support, dimensions, etc.
  def Tgio::terminaldetect
        term = JLine::Terminal.terminal.new
    terminfo = {
      :supported  => term.is_supported,
      :ansi       => term.is_ansisupported,
      :height     => term.getTerminalHeight,
      :width      => term.getTerminalWidth,
      :echo       => term.is_echo_enabled
    }
    return terminfo
  end

  # Asks user a question. Wraps display of a template and inputform.
  def Tgio::question(template, inputsize, type='text')
    t = Tgtemplate::Template.new(template)
    t.render()
    if inputsize > 1
      answer = Tgio::Input.inputform(inputsize, type)
    elsif inputsize == 1
      answer = Tgio::Input.inputkey
    end    
    return answer
  end

  # Displays menu from template and prompts user for inputkey.
  def Tgio::menu(template)
    t = Tgtemplate::Template.new(template)
    t.render()
    selection = Tgio::Input.inputkey
    return selection
  end


end #/module
