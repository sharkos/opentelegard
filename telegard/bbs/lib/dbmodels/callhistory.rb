=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/callhistory.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: External Programs Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== Callhistory Structure

=end


class Tgcallhistory < Sequel::Model(:callhistory)
  Tgio.printstart " DB Model: callhistory"
 
  if empty?
    #create  :label => 'value'
  end
  Tgio.printreturn(0)

# Calculates the total time a specific user by id has spent in callhistory in a 24hour period
def thisuser_time_today(uid = self.user_id)
  today = 0
  dataset = $db[:callhistory].where(:user_id => uid).filter(:time_login =>(Time.now - 24.hours)..(Time.now))
  dataset.each do |ds|
    unless ds[:time_logout].nil?
      timediff = (ds[:time_logout] - ds[:time_login]).to_i.sec_to_min
      today += timediff
    end #/unless
  end #/do
  return today
end #/def

# Calculates the total login count for a specific user by id in a 24hour period
def thisuser_logincount_today(uid = self.user_id)
  today = 0
  dataset = $db[:callhistory].where(:user_id => uid).filter(:time_login =>(Time.now - 24.hours)..(Time.now))
  return dataset.count
end #/def



end #/class

