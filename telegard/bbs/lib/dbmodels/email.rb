=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011   LeafScale Systems, LLC
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

 Source File: /lib/dbmodels/email.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Email Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== Email Structure
 Email data is split between various tables in the database
=end


# Email Structure (must be named Tgemail)
class TgemailInbox < Sequel::Model(:inbox)
  Tgio.printstart " DB Model: email - inbox"
  # => Create association of ONE Group to Many Users

  many_to_one :user

  if empty?
    # Test data for DropBox - Criteria = New Uploaded file, not approved nor enabled. SHA256 Checksum used.
    create  :user_id => '1',
            :from_id => '1',
            :read => false,
            :network => false,            
            :from => 'Telegard/2 Project Team',
            :to => 'NEW SYSOP',
            :subject => 'Welcome to Telegard/2 - a note from the developer.',
            :composed => Time.now,
            :received => Time.now,
            :read_at => nil,
            :body => <<eol
Hello!

Welcome to the Telegard/2 Operating Subsystem. This software is the result
of years of hard work and dedication by the project's team of developers.
We hope that you will enjoy the features and innovation of this product.
This email is auto-generated one time only, and dropped into the Inbox of
the master user or SYSOP account during installation.

Information on using this software is always available on the main project
website: http://www.telegard.org  and on IRC  #telegard @ irc.FreeNode.net

Have fun! And be sure to stay updated on the latest releases, and changes.

Sincerely,
Chris Tusa
inet:  chris.tusa@telegard.org
tgnet: <coming soon>
eol

  end
  Tgio.printreturn(0)
end
