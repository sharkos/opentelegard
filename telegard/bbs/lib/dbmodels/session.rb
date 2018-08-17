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

 Source File: /lib/dbmodels/session.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Session Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== Session Structure

=end


# Session Structure
class Session < Sequel::Model(:sessions)
  Tgio.printstart " DB Model: sessions"

  if empty?
    #create  :label => 'value'
  end

  # Get current user by login name and return instance.
  def getcuruser
    $db[:users].where(:id => $session.user_id).first
  end

  # Get group of current user and return instance.
  def getcurgroup
    $db[:groups].where(:id => $session.group_id).first
  end

  # Set the session expiration time. This is determined
  # Based on the amount of user's daily alloted time,
  # substracted by the amount of time used so far today,
  # then compared to the current time to create a time value
  # of when the expiration will occur.
  def setexpiration
    return -1
  end

  # Returns value of session's remaining time in minutes
  def timeremain    
    return ($session.expires - Time.now).to_i.sec_to_min
  end

  # Check if the session is valid.
  def is_valid?
    if $session && $session.expires >= Time.now || self.timeremain >= 0
      return true
    end
  end

  Tgio.printreturn(0)
end

