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

 Source File: /lib/dbmodels/file.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: File Schema for Database

-----------------------------------------------------------------------------


=begin rdoc
= Tgdatabase_models (Database Models)
Tgdatabase_models defines the Sequel Model classes for the data structures.

== File Areas Structure

=end


# File Structure (must be named Tgfile - cannot conflict with Ruby 'File' class
class Tgfile < Sequel::Model(:files)
  Tgio.printstart " DB Model: files"
  # => Create association of ONE Group to Many Users
  many_to_one :tgfilearea
  many_to_one :user

  if empty?
    # Test data for DropBox - Criteria = New Uploaded file, not approved nor enabled. SHA256 Checksum used.
    create  :tgfilearea_id => '1',
            :owner_id => 2,
            :uploaded_by => 2,
            :approved_by => nil,
            :enabled => false,
            :filename => 'newfile.txt',
            :name => 'Test New File in Dropbox',
            :description => 'This is a sample file entry to test the dropbox write only feature',
            :checksum => '1eea6bb329004ebebc7a6c7fee0e4de7a458badd44c3c91ec49c4244a92b6e11',
            :version => '1.0',
            :vendor => 'LeafScale Systems, LLC',
            :license => 'Creative Commons License',
            :url => 'http://www.leafscale.com/telegard',
            :size => '468',
            :mtime => Time.now,
            :created_at => Time.now,
            :modified_at => Time.now

    # Test data for Default - Criteria = No Uploads Allowed, Read Only, Enabled & Approved
    create  :tgfilearea_id => '2',
            :owner_id => 1,
            :uploaded_by => 1,
            :approved_by => 1,
            :enabled => true,
            :filename => 'ready.txt',
            :name => 'Enabled File in Default',
            :description => 'This is a sample file entry to test the default read only feature',
            :checksum => 'ae86c22efc2f0da5dbae4e2c5e3c18ba2346d0f38938d43f2d4d85ca53509baf',
            :version => '1.0',
            :vendor => 'LeafScale Systems, LLC',
            :license => 'Creative Commons License',
            :url => 'http://www.leafscale.com/telegard',
            :size => '396',
            :mtime => Time.now,
            :created_at => Time.now,
            :modified_at => Time.now

    create  :tgfilearea_id => '2',
            :owner_id => 1,
            :uploaded_by => 1,
            :approved_by => 1,
            :enabled => false,
            :filename => 'notready.txt',
            :name => 'Disabled file in default',
            :description => 'This file should be in default, but hidden from users via Enabled False',
            :checksum => '1a5c2ed17fbd5a49b14092f6754d90344bc9618eeae8e5ca893df9fb65314b54',
            :version => '1.0',
            :vendor => 'LeafScale Systems, LLC',
            :license => 'Creative Commons License',
            :url => 'http://www.leafscale.com/telegard',
            :size => '396',
            :mtime => Time.now,
            :created_at => Time.now,
            :modified_at => Time.now



  end
  Tgio.printreturn(0)
end
