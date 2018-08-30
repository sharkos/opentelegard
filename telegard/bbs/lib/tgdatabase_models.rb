=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/tgdatabase_models.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Define Database Models. This file can only be called after a
              Sequel database instance has been created.

-----------------------------------------------------------------------------


=begin rdoc               
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== User Structure
The Users & Group models are designed to work as follows:
*  a User holds only the personal data.
*  a Group holds the permissions & limits.
*  a User can only belong to one group.
*  a User with "ADMIN" rights to Users or Groups cannot view or modify
   entries with greater privilege level (Security).
*  a Group has a "level" field which defines the security level. This
   allows the admin to create "custom" groups with varying levels of
   access. The lower the level value, the higher the access
   (integer >= [1..100]).

=end


# Sequel::Model.plugin(:schema) # This plugin was depreacted in gem Sequel >= v4.5
require 'lib/dbmodels/group'
require 'lib/dbmodels/user'
require 'lib/dbmodels/network'
require 'lib/dbmodels/filearea'
require 'lib/dbmodels/file'
require 'lib/dbmodels/msgarea'
require 'lib/dbmodels/msg'
require 'lib/dbmodels/chatroom'
require 'lib/dbmodels/extprogs'
require 'lib/dbmodels/session'
require 'lib/dbmodels/callhistory'
require 'lib/dbmodels/bbslist'

