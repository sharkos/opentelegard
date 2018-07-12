=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011   LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2008-2011, LeafScale Systems, LLC
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

 Source File: /lib/controllers/callhistory.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Call History controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= CallHistoryController
The CallHistory menu controller.
=end

class CallHistoryController < Tgcontroller
  
  def initialize
    $session.current_area = "Call History"
    $session.save
  end

  def menu    
    done = false
    validkeys=['A', 'D', 'F', 'M', 'T', 'X']
    until done == true      
      key = Tgio::Input.menuprompt('menu_callhistory.ftl',validkeys, nil) # nil is for tpl vars hash
      test_session
      print "\n"
      case key
        when "A" # View All
          callers = Tgtemplate::Template.parse_dataset($db[:callhistory].all)          
          Tgtemplate.display('callhistory.ftl', {'title'=> 'All Logged Calls','callers'=>callers})
        when "D" # Show by date
          searchdate = Tgio::Dates::inputdate
          #callers    = Tgtemplate::Template.parse_dataset($db[:callhistory].filter(:time_login => (DateTime.parse(searchdate.asctime))..(DateTime.parse(searchdate.asctime) +1)).all)
          callers    = Tgtemplate::Template.parse_dataset($db[:callhistory].filter(:time_login => (DateTime.parse(searchdate.asctime))..(DateTime.parse(searchdate.asctime) +1)).all)
          Tgtemplate.display('callhistory.ftl', {'title' => "#{searchdate} History",'callers'=>callers})
        when "M" # Show history for current user
          callers = Tgtemplate::Template.parse_dataset($db[:callhistory].filter(:user_id => $session.user_id).all)
          Tgtemplate.display('callhistory.ftl', {'title' => "#{$callerid.alias}'s History",'callers'=>callers})
        when "F" # Search history by some username
          #Telegard.unimplemented
          searchuser = Tgio::Input::inputform(16).upcase
          callers = Tgtemplate::Template.parse_dataset($db[:callhistory].filter(:alias => searchuser).all)          
          Tgtemplate.display('callhistory.ftl', {'title'=> "Calls for #{searchuser}",'callers'=>callers})
        when "T" # Show Today's callers
          searchdate = Date.today
          callers    = Tgtemplate::Template.parse_dataset($db[:callhistory].filter(:time_login => (DateTime.parse(searchdate.asctime))..(DateTime.parse(searchdate.asctime) +1)).all)
          Tgtemplate.display('callhistory.ftl', {'title' => "Callers Today", 'callers'=>callers})
        when "X" # "Return to Main"
          return 0
      end #/case
      test_session
    end #/until
  end #/def menu
 
end