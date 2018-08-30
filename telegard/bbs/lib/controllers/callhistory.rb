=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/callhistory.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
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
