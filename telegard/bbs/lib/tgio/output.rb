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

 Source File: /lib/tgio/output.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Output Handler Library

-----------------------------------------------------------------------------
=end

=begin rdoc
= Output
Output provides routines to handle displaying to console.
=end


module Tgio
  module Output

    # This class provides class methods for paging and an object which can conditionally page given a terminal size that is exceeded.
    # adapted from Hirb gem: credit to Gabriel Horner
    class Pager
      class<<self

        # Pages with a ruby-only pager which either pages, displays remaining or quits.
        def default_pager(output, options={})
          pager = new(options[:width], options[:height])
          while pager.activated_by?(output)
            puts pager.slice!(output)
            pt = Tgtemplate::Template.new('pager_default.ftl').stringify.chomp
            print pt
            prompt = Tgio::Input.pagerkey_default
            if prompt.upcase == 'N' # Stop Paging
              return
            elsif prompt.upcase == 'Y' # Next Page
              print " \b\b \b" * (pt.length + 1)
            elsif prompt.upcase == 'C' # Continue
              print " \b\b \b" * (pt.length + 1)
              break
            end
            #return unless continue_paging?
          end          
          print output
        end

        private
        def basic_pager(output)
          pager = IO.popen(pager_command, "w")
          begin
            save_stdout = STDOUT.clone
            STDOUT.reopen(pager)
            STDOUT.puts output
          rescue Errno::EPIPE
          ensure
            STDOUT.reopen(save_stdout)
            save_stdout.close
            pager.close
          end
        end

#        def continue_paging?
#          print "=== Press enter/return to continue or q to quit: ==="
#          !$stdin.gets.chomp[/q/i]
#        end
        #:startdoc:
      end

      attr_reader :width, :height

      # Create a new instance of Pager with defaults
      def initialize(width=80, height=24)
        resize(width, height)
      end

      # Pages given string using configured pager.
      def page(string)
        self.class.default_pager(string, :width=>@width, :height=>@height)
        string.replace("") # Blank String to clear for next run
      end

      def slice!(output) #:nodoc:
        effective_height = @height - 1 # takes into account pager prompt
        # could use output.scan(/[^\n]*\n?/) instead of split
        sliced_output = output.split("\n").slice(0, effective_height).join("\n")
        output.replace output.split("\n").slice(effective_height..-1).join("\n")
        sliced_output
      end

      # Determines if string should be paged based on configured width and height.
      def activated_by?(string_to_page)
        string_to_page.count("\n") > @height
      end

      # Set the size of the end-users's terminal by probing via JLine
      def resize(width, height) #:nodoc:
        @width =  JLine::ConsoleReader.new.getTermwidth
        @height = JLine::ConsoleReader.new.getTermheight
      end
    end #/class

  end #/module Output
end #/module Tgio

