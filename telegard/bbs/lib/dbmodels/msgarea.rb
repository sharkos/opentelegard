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

 Source File: /lib/dbmodels/msgarea.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: MsgArea Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== File Areas Structure

=end

# Messsages Area Structure
class Tgmsgarea < Sequel::Model(:msgareas)
  Tgio.printstart " DB Model: msgareas"
  # => Create association of ONE Group to Many Users
  one_to_many :msgs

  if empty?
    # GENERAL : A default message group - Anyone can read, only members of "USERS" group (level 100) can write
    create  :name           => 'GENERAL',
            :description    => 'General user discussion on this system.',
            :network        => false,
            :network_id     => nil,
            :minlevel_read  => 1,
            :minlevel_write => 100,
            :enabled        => true,
            :created        => Time.now

    # TELEGARD : A default message group - Only members with group level >= 100 (USERS) can read and write
    create  :name           => 'TELEGARD',
            :description    => 'Telegard Software discussion.',
            :network        => false,
            :network_id     => nil,
            :minlevel_read  => 100,
            :minlevel_write => 100,
            :enabled        => true,
            :created        => Time.now

    # SYSADMINS : A default message group - Only members with group level >= 200 (COSYSOPS) can read or write
    create  :name           => 'SYSADMINS',
            :description    => 'System Administrators Only',
            :network        => false,
            :network_id     => nil,
            :minlevel_read  => 200,
            :minlevel_write => 200,
            :enabled        => true,
            :created        => Time.now

    # DISABLED : A default message group - set by default to "enabled == false"
    create  :name           => 'DISABLED',
            :description    => 'Sample area that should be hidden from view.',
            :network        => false,
            :network_id     => nil,
            :minlevel_read  => 1,
            :minlevel_write => 255,
            :enabled        => false,
            :created        => Time.now

    # TGNET_NEWS : A default TGNet network feed
    create  :name           => 'TGNET_NEWS',
            :description    => 'News from the Telegard Network',
            :network        => true,
            :network_id     => 1,
            :minlevel_read  => 1,
            :minlevel_write => -1,
            :enabled        => true,
            :created        => Time.now


  end #/if empty?
  Tgio.printreturn(0)
end
