=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/session.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
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

  # Adjust the session remaining time by a specific value (an integer of minutes)
  # a negative value will decrease the time, whereas a positive will increase
  def timeadjust(val=0)
    $session.expires = $session.expires + (val * 60)
    $session.save
  end

  # Check if the session is valid.
  def is_valid?
    if $session && $session.expires >= Time.now || self.timeremain >= 0
      return true
    end
  end

  Tgio.printreturn(0)
end

