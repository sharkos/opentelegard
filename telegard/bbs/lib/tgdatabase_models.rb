=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2018   LeafScale Systems, LLC
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

