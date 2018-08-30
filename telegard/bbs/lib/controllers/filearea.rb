=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/filearea.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: FileArea controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= FileAreaController
The Main Menu master controller.
=end


class FileAreaController < Tgcontroller
  # FileArea Menu Handler
  def menu
    done = false
    validkeys=['A','D','J','L','N','S','U','V',']','[','X']
    until done == true

      # Retrieve a list and count of File Areas - This is done each menu loop in the event soemthing changes
      # by an admin during the user's session. Potentially, a change could cause the controller to crash.
      arealist  = $db[:fileareas].select(:id).order(:id).map(:id)
      areacount =  $db[:fileareas].count

      # Track the user's current area from the session table.
      if $session.filearea.nil? == true
        curarea = arealist.first
        $session.filearea = curarea
        $session.save
      else
        curarea = $session.filearea
      end
      # Set the array iterator index location
      areaindex = arealist.index(curarea)
      # Get area's metadata info
      areameta = $db[:fileareas].where(:id => curarea).first
      # Get a count of total files in this area
      filecount = $db[:files].filter(:tgfilearea_id => $session.filearea).count

      # Display menu
      key = Tgio::Input.menuprompt('menu_filearea.ftl',validkeys, {"areanum" => areameta[:id].to_s,"areaname" => areameta[:name].capitalize, "areadesc" => areameta[:description], "areacount" => filecount })
      print "\n"
      case key
        when "A" # List all File Area Names/Descriptions
          areas = Tgtemplate::Template.parse_dataset($db[:fileareas].all)          
          Tgtemplate.display('filearea_list_areas.ftl', {'areas' => areas})

        when "D" # Prompt user to download a file by file.id
          Telegard.unimplemented

        when "J" # Jump to another area
          Tgtemplate.display('filearea_jumpto.ftl', nil)
          jumper = Tgio::Input::inputform(4).to_i
          # Validate input for correctness before switching areas
          if arealist.include?(jumper) == true
            $session.filearea = jumper
            $session.save
          else
            Tgtemplate.display('filearea_jumpto_invalid.ftl', nil)
          end

        when "L" # List files in current area
          if areameta[:read] == true
            filelist = Tgtemplate::Template.parse_dataset($db[:files].filter(:tgfilearea_id => $session.filearea, :enabled =>true).all)
            Tgtemplate.display('filearea_list_files.ftl', {'files' => filelist, 'areaname' => areameta[:name].capitalize})
          else                                                                                        
            Tgtemplate.display('filearea_read_forbidden.ftl', {'areaname'=>areameta[:name].capitalize})
          end

        when "N"
          Telegard.unimplemented

        when "S" # Search for Files
          Telegard.unimplemented

        when "T" # Tag file for download queue
          Telegard.unimplemented

        when "U" # Upload a File
          Telegard.unimplemented

        when "V" # View File Metadata
          filenum = Tgio::Input::inputform(6).to_i
          metaset = $db[:files].where(:id => filenum).first
          unless metaset.nil? == true # Check if result set is valid
            if metaset[:enabled] == true # Only show data if file is enabled              
              metaset[:uploaded_by] =  $db[:users].select(:login).where(:id => metaset[:uploaded_by]).first[:login]
              metaset[:approved_by] = $db[:users].select(:login).where(:id => metaset[:approved_by]).first[:login]
              metaset[:owner_id] = $db[:users].select(:login).where(:id => metaset[:owner_id]).first[:login]
              Tgtemplate.display('filearea_file_metadata.ftl', {'file'=> Tgtemplate::Template.parse_hash(metaset)})
            else
              Tgtemplate.display('filearea_file_invalid.ftl',nil)
            end
          else
            Tgtemplate.display('filearea_file_invalid.ftl', nil)
          end

        when "]" # Next Area
          if areaindex > (areacount - 1)
            $session.filearea = arealist.first
          else
            $session.filearea = arealist.at(areaindex + 1)
          end
          $session.save

        when "[" # Previous Area
          if areaindex <= 0
            $session.filearea = arealist.last
          else
            $session.filearea = arealist.at(areaindex - 1)
          end
          $session.save

        when "X"
          return 0
      end #/case
    end #/until
  end #/def menu
 
end
