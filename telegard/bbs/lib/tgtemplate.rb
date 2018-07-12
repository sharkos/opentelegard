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

 Source File: /lib/tgtemplate.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Template parsing Library

-----------------------------------------------------------------------------
=end

=begin rdoc               
= Tgtemplate (Template)
Tgtemplate provides the wrapper for the FreeMarker template engine JAR file.
=end
module Tgtemplate

begin
  require 'class/freemarker.jar'
rescue LoadError
  raise "ERROR: unable to load embedded database engine."
end

# Import of Java Class for FreeMarker Template Engine
module Fm
   include_package "freemarker.template"
end



unless File.exist?(TPL_DIR+'/'+$cfg['bbs']['theme'])
  puts "[ERROR] Could not located user defined theme. Falling back to default."
  themedir = TPL_DEFAULT
else
  themedir = $cfg['bbs']['theme']
end



$tcfg = Fm::Configuration.new()
  $tcfg.setDirectoryForTemplateLoading(JavaIO::File.new("./tpls/#{themedir}"))
  $tcfg.setObjectWrapper(Fm::DefaultObjectWrapper.new)


# The template class. Used to create an instance of template from an action
class Template
   # Sets values when calling new method for a template
   def initialize(filename)
      @tout = JavaIO::OutputStreamWriter.new(JavaLang::System.out)
      @template = $tcfg.getTemplate(filename)
      @tbbs = JavaUtil::HashMap.new
      @tcolors = JavaUtil::HashMap.new
      @tcuruser = JavaUtil::HashMap.new
      @tdata = JavaUtil::HashMap.new
      @tcfgsignup = JavaUtil::HashMap.new

      # Push ansicolors into Global Template vars as color.
      ANSICOLORS.each do |key, value|
            @tcolors.put(key, value)
      end
      # Push BBS Config values into Global Template vars as bbs
      $cfg['bbs'].each do |key, value|
        @tbbs.put(key,value)
      end

      # Push Signup Config values into Global Template vars as bbs
      $cfg['signup'].each do |key, value|
        @tcfgsignup.put(key,value)
      end

   end

   # Renders the template to stdout
   def render(data={})
      if data.class == Hash
         data.each do |key, value|
            @tdata.put(key, value)
         end
         @tdata.put("bbs", @tbbs)
         @tdata.put("color", @tcolors)
         @tdata.put("signup", @tcfgsignup)
         if $session
           @tdata.put("username", $session.username)
           @tdata.put("session_expires", $session.expires.to_s)
           @tdata.put("session_timeremain", $session.timeremain.to_s)
         end
         @template.process(@tdata, @tout)
         @tout.flush
      else
         puts "Tgtemplate: Parsing error - data not of type Ruby::Hash. Type was (#{data.class})"
      end
   end #/def


   # Renders the template to a string so it may be paged using the Pager facility
   def stringify(data={})
      if data.class == Hash
         data.each do |key, value|
            @tdata.put(key, value)
         end
         @tdata.put("color", @tcolors)
         @tdata.put("bbs", @tbbs)
         @tdata.put("signup", @tcfgsignup)
         if $session
           @tdata.put("username", $session.username)
           @tdata.put("session_expires", $session.expires.to_s)
           @tdata.put("session_timeremain", $session.timeremain.to_s)
         end
         @sout = JavaIO::StringWriter.new()

         @template.process(@tdata, @sout)
         return @sout.toString
      else
         puts "Tgtemplate: Parsing error - data not of type Ruby::Hash. Type was (#{data.class})"
      end
   end #/def



    # Parses an array of hashes created by a Sequel Dataset, and constructs a new
    # array of JavaUtil::HashMap(s) with the keys converted from symbols to string.
   def Template.parse_dataset(sqlset)
     if sqlset.class == Array
       newarray = []
       sqlset.each do |h|
         if h.class == Hash
           newhash = JavaUtil::HashMap.new
           h.each_pair do |k ,v|
             newhash.put(k.to_s, v)
           end
         end
         newarray.push(newhash)
       end
     end
     return newarray
   end

    def Template.parse_hash(sqlset)
     if sqlset.class == Hash
           newhash = JavaUtil::HashMap.new
           sqlset.each_pair do |k ,v|
             newhash.put(k.to_s, v)
           end
     end
     return newhash
   end

end #/class

  # Display a template file. If a hash is passed in, then variables
  # will be substituted by FreeMarker.
  def Tgtemplate::display(template, hashdata=nil)
    t = Tgtemplate::Template.new(template)
    p = Tgio::Output::Pager.new
    if hashdata == nil
      if $session.nil? == false && $session.pref_term_pager == true
        p.page(t.stringify())
      else
        t.render()
      end
    else
      if $session.nil? == false && $session.pref_term_pager == true
        p.page(t.stringify(hashdata))
      else
        t.render(hashdata)
      end
    end
    # Ensure ANSI colors are reset after template display.
    print ANSI_RESET
  end

=begin ## OLD DISPLAY BEFORE INTEGRATING PAGER ##
  # Display a template file. If a hash is passed in, then variables
  # will be substituted by FreeMarker.
  def Tgtemplate::display(template, hashdata=nil)
    t = Tgtemplate::Template.new(template)
    if hashdata == nil
      t.render()
    else
      t.render(hashdata)
    end
    # Ensure ANSI colors are reset after template display.
    print ANSI_RESET
  end
=end


end #/module
