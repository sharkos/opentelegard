=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
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
