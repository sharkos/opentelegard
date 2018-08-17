=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011,  LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2008-2011, Chris Tusa & LeafScale Systems, LLC
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

 Source File: /lib/dbmodels/network.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Network Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== Network Structure

=end


# Network Sequel CLass
class Network < Sequel::Model(:networks)
  Tgio.printstart " DB Model: network"

  if empty?
    # Default Telegard Network
    create  :name        => 'TGNet',
            :description => 'The official Telegard/2 Network',
            :protocol    => 'telegard',
            :enabled     => false,
            :lastsync    => nil,
            :created     => Time.now,
            :tgnet_directory => 'directory.tgnet.telegard.org',
            :tgnet_node      => 'unidentified'

    create  :name        => 'FidoNET',
            :description => 'The official FidoNET Network',
            :protocol    => 'fidonet',
            :enabled     => false,
            :lastsync    => nil,
            :created     => Time.now,
            :fidonet_node=> '1:999/999'

    create  :name        => 'WWIVnet',
            :description => 'The official WWIV Network',
            :protocol    => 'wwivnet',
            :enabled     => false,
            :lastsync    => nil,
            :created     => Time.now,
            :wwivnet_node=> '99999'



  end
  Tgio.printreturn(0)
end
