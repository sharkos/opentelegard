=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
                  Copyright (C) 2010, LeafScale Systems, LLC
                            http://www.opentg.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2010, LeafScale Systems, LLC
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

 Source File: /lib/controllers/file.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: File controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= FileController
The File controller.
=end

class FileController < Tgcontroller

  def initialize(curarea)
    @areameta = $db[:fileareas].where(:id => curarea).first
    # Create instance of Area's DB
    dbcfg = $cfg['database']
    @areadb = Sequel.connect("jdbc:h2:tcp://localhost/fileareas/#{@areameta[:id]}", :user => dbcfg['user'], :password=>Security::ConfigPassword.new.decrypt(dbcfg['pass']))
    unless @areadb.table_exists?(:files) == true
      @areadb.create_table :files do
        primary_key  :id              # File ID
        integer      :tgfilearea_id   # Area ID
        integer      :owner_id        # File Owner (maintainer)
        integer      :uploaded_by     # User who submitted file
        integer      :approved_by     # User who approved file (if any)
        boolean      :enabled         # File available for download?
        String       :filename        # Filename
        String       :name            # Friendly Short Name
        text         :description     # Long description
        text         :checksum        # Some Checksum Value (MD5/SHA,etc)
        String       :version         # Version of file (optional)
        String       :vendor          # Vendor of the file (optional)
        String       :license         # License file distributed under (optional)
        String       :url             # URL for more information (optional)
        integer      :size            # Size of file in bytes on storage
        integer      :downloaded      # Number of downloads
        TimeStamp    :mtime           # File's mtime on storage
        TimeStamp    :created_at      # Time file added to DB
        TimeStamp    :modified_at     # Time file modified in DB
      end
    end
  end

  def uninitialize
    # Disconnect and destroy instance
    @areadb.disconnect
    @areadb = nil
  end


  def menu
    done = false
    validkeys=['/G']
    until done == true
      key = Tgio::Input.menuprompt('menu_file.ftl',validkeys, nil) # nil is for tpl vars hash
      print "\n"
      case key
        when "/G"
          puts "Goodbye!"
          done = true
          return 0
      end #/case
    end #/until
  end #/def menu
 
end