=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/dbmodels/network.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
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
