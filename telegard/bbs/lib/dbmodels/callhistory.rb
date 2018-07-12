=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
                  Copyright (C) 2010, LeafScale Systems, LLC
                           http://www.telegard.org
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

 Source File: /lib/dbmodels/callhistory.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: External Programs Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== Callhistory Structure

=end


class Tgcallhistory < Sequel::Model(:callhistory)
  Tgio.printstart " DB Model: callhistory"
  set_schema do
    primary_key  :id
    integer      :user_id
    String       :alias       # Added for convenience.        
    Timestamp    :time_login
    TimeStamp    :time_logout
  end

  create_table unless table_exists?

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

