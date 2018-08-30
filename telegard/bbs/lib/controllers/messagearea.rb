=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/messagearea.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: MessageArea controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= MessageAreaController
The Message Area controller.
=end


class MsgareaController < Tgcontroller


  def menu
    done = false
    validkeys=['A','G','I','J','L','N','O','R','S',']','[','X']
    until done == true

      # Retrieve a list and count of Message Areas - This is done each menu loop in the event soemthing changes
      # by an admin during the user's session. Potentially, a change could cause the controller to crash.
      arealist  = $db[:msgareas].where(:enabled => true).select(:id).order(:id).map(:id)
      areacount =  $db[:msgareas].count
      # Track the user's current area from the session table.
      if $session.msgarea.nil? == true
        curarea = arealist.first
        $session.msgarea = curarea
        $session.save
      else
        curarea = $session.msgarea
      end
      # Set the array iterator index location
      areaindex = arealist.index(curarea)
      # Get area's metadata info
      areameta = $db[:msgareas].where(:id => curarea).first
      # Get a count of total files in this area
      msgcount = $db[:msgs].filter(:msgarea_id => $session.msgarea).count
      # Get network information
      if areameta[:network] == true #(network)
        network = Tgtemplate::Template.parse_hash($db[:networks].where(:id => areameta[:network_id]).first)
      else
        network = nil
      end

      # Display menu
      key = Tgio::Input.menuprompt('menu_msgarea.ftl',validkeys, {"areanum" => areameta[:id].to_s,"areaname" => areameta[:name].capitalize, "areadesc" => areameta[:description], "areacount" => msgcount })
      print "\n"
      case key
        when "A" # List all Message Area Names/Descriptions
          areas = Tgtemplate::Template.parse_dataset($db[:msgareas].where(:enabled => true).all)
          Tgtemplate.display('msgarea_list_areas.ftl', {'areas' => areas})

        when "G" # Message Reader
          Telegard.goodbye

        when "R" # Message Reader
          MessageController.new(curarea).browse

        when "I" # Area Information
          Tgtemplate.display('msgarea_area_meta.ftl', {'area' => Tgtemplate::Template.parse_hash(areameta), 'network' => network})

        when "J" # Jump to another area
          Tgtemplate.display('msgarea_jumpto.ftl', nil)
          jumper = Tgio::Input::inputform(4).to_i
          # Validate input for correctness before switching areas
          if arealist.include?(jumper) == true
            $session.msgarea = jumper
            $session.save
          else
            Tgtemplate.display('msgarea_jumpto_invalid.ftl', nil)
          end

        when "L" # List messages in current area
          if $session.level >= areameta[:minlevel_read]
            MessageController.new(curarea).listall
          else
            Tgtemplate.display('msgarea_read_forbidden.ftl', {'areaname'=>areameta[:name].capitalize})
          end

        when "N" # Network Memberships
          Telegard.unimplemented

        when "P" # Post Area
            MessageController.new(curarea).post

        when "S" # Search for Message in All Areas
          Telegard.unimplemented

        when "]" # Next Area
          if areaindex > (areacount - 1)
            $session.msgarea = arealist.first
          else
            $session.msgarea = arealist.at(areaindex + 1)
          end
          $session.save

        when "[" # Previous Area
          if areaindex <= 0
            $session.msgarea = arealist.last
          else
            $session.msgarea = arealist.at(areaindex - 1)
          end
          $session.save

        when "X"
          return 0

      end #/case
    end #/until
  end #/def menu

end
