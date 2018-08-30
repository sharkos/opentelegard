=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/tgio/tgedit.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Message controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= Tgedit
An ANSI console editor for composing short, simple documents such as Telegard
Email or longer input fields. Editors defined by this module should all
follow the same basic principle of handling user I/O and returning a string
object as the body of the editor content to the calling function.
=end


module Tgio
  module Tgedit

    # Load the user's defined editor and returns content to the caller
    def Tgedit.edit(content=nil)
       case $session.pref_editor
         when 'nano'
           t = Tgio::Tgedit::Nano.new(content)
           t.exec
           return t.parse_content
         else
           return Tgio::Tgedit::Telegard.new.edit
       end
    end

    # The OpenTelegard ANSI Editor
    class Telegard
      # Create a new instance of the editor
      def initialize
        @buffer = []  # Create an empty array
        @lines = 0    # Line counter starts at zero
      end

      # Displays a banner before starting the editor with information on usage, etc.
      def banner
        Tgtemplate.display('tgedit_banner.ftl')        
      end

      # Input a row of text and add it to the buffer until exit is called.
      def inputrow
        skipline = false
        newline = Tgio::Input.inputeditline(79)
        if newline.length == 2
          case newline
            when "/A" # Abort
              Tgtemplate.display('tgedit_abort.ftl')
              return 2
            when "/X" # Exit and Save
              return 1
            when "/H" # Help
              Tgtemplate.display('tgedit_help.ftl')
              skipline = true
            when "/P" # Preview & Change
              preview
              skipline = true
          end #/case
        end #/if
        @buffer.push(newline) unless skipline == true
        return 0
      end #/def inputrow

      # Run Editor Session
      def edit
        loop = true
        banner
        while loop == true
          row = inputrow
          if row == 1
            loop = false
          elsif row == 2
            loop = false
            return nil
          end
        end #/while
        body = ""
        @buffer.each do |line|
          body = body + line + "\n"
        end
        return body
      end

      # Previews the lines, allowing the user to make a change before saving
      def preview
        linenum = 0
        puts "\n"
        @buffer.each do |line|
          linenum +=1
          puts "#{linenum.to_s}:#{line}"
        end
      end

    end #/class Editor

    # Load GNU Nano restricted mode
    class Nano

      def initialize(content=nil)
        @filename = "/tmp/telegard-#{$session.user_id}-#{$session.id}-#{Time.now.to_i}"
        unless content.nil? == true
          f = File.new(@filename, "w")
            f.puts(content)
          f.close
        end
      end

      # Load filename using rnano
      def exec
         strptrs = []
         strptrs << FFI::MemoryPointer.from_string("/bin/rnano")   # Restricted Nano
         strptrs << FFI::MemoryPointer.from_string("-t")           # -t for use tmpfile (no save prompt)
         strptrs << FFI::MemoryPointer.from_string("#{@filename}") # generated tmp filename 
         strptrs << nil

         # Now load all the pointers into a native memory block
         argv = FFI::MemoryPointer.new(:pointer, strptrs.length)
         strptrs.each_with_index do |p, i|
          argv[i].put_pointer(0,  p)
         end
         if JExec.fork == 0
          JExec.execvp("/bin/rnano", argv)
         end
         Process.waitall
      end

      # Parse the content of @filename and return it
      def parse_content
        body = ""
        if File.exists?(@filename)
          f = File.open("#{@filename}", "r")
            f.each_line do |line|
              body += line
            end #/do
          f.close
          File.delete(@filename)
          return body
        else
          Tgtemplate.display('tgedit_abort.ftl')
          return nil
        end #/if
      end #/def

    end #/class Nano

  end #/module Tgedit

end #/module Tgio
