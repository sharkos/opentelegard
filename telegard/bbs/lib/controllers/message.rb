=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011,  LeafScale Systems, LLC
                           http://www.telegard.org
               ================================================


---[ License & Distribution ]------------------------------------------------

Copyright (c) 2008-2011, LeafScale Systems, LLC
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

 Source File: /lib/controllers/message.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Message controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= MessageController
The Message controller.
=end

class MessageController < Tgcontroller

  def initialize(curarea)
    @areameta = $db[:msgareas].where(:id => curarea).first
    # Create instance of Area's DB
    dbcfg = $cfg['database']
    @areadb = Sequel.connect("jdbc:h2:tcp://localhost/msgareas/#{@areameta[:id]}", :user => dbcfg['user'], :password=>Security::ConfigPassword.new.decrypt(dbcfg['pass']))
    unless @areadb.table_exists?(:msgs) == true
      @areadb.create_table :msgs do
        primary_key  :id              # Message ID
        integer      :msgarea_id      # Message Area ID
        integer      :from_id         # ID of sender
        boolean      :network         # ? Message is Local or Network
        integer      :network_id      # ID of network (in network configs)
        String       :network_node    # Network address of remote node
        String       :from            # From Header
        String       :to              # To Header
        String       :cc              # CC Header
        String       :subject         # Subject Header
        text         :body            # Message
        TimeStamp    :composed        # Message composed timestamp
        TimeStamp    :received        # Message received timestamp
        array        :read_by         # List of user_id's that have read this item
      end
    end
  end

  def uninitialize
    # Disconnect and destroy instance
    @areadb.disconnect
    @areadb = nil
  end

  # Display summary listing of ALL message areas.
  def listall
    # Connect to message area database
    #areadb = Sequel.connect("jdbc:h2:tcp://localhost/msgareas/#{areameta[:id]}", :user => db['user'], :password=>Security::ConfigPassword.new.decrypt(db['pass']))
    # Check if message table exists. If not, create it
    msglist = Tgtemplate::Template.parse_dataset(@areadb[:msgs].select(:id, :subject, :from, :composed).all)
    Tgtemplate.display('msgarea_list_msgs.ftl', {'msgs' => msglist, 'areaname' => @areameta[:name].capitalize})
  end

  # View current message
  def view(msgmeta)
    Tgtemplate.display('msg_display.ftl', {"from"=> msgmeta[:from],
                                           "subject"=>msgmeta[:subject],
                                           "composed" => msgmeta[:composed],
                                           "body" => msgmeta[:body]})
  end

  # Post a new message 
  def post
    Tgtemplate.display('msgarea_confirm_postnew.ftl', {'areaname'=>@areameta[:name].capitalize})
    if Tgio::Input::inputyn == true
      Tgtemplate.display('msgarea_post_asksubject.ftl')
      subject = Tgio::Input.inputform(75)
      body = Tgio::Tgedit::edit
      # TODO : Enable error checking via try/catch
      unless body == nil
        #TODO: Ask user to confirm they are happy with the post before saving
        msg = @areadb[:msgs]
        msg.insert(:msgarea_id => @areameta[:id],
                   :from_id => $session.user_id,
                   :from => $session.username,
                   :subject => subject,
                   :body => body,
                   :composed => Time.now
                )
        Tgtemplate.display('msgarea_post_success.ftl')
      end
    end
  end

  # Add quote notation to original message for use in reply
  def quote(original)
    quoted = "> ---------------------------------------------------------------------\n> Original Message : #{original[:composed]} by #{original[:from]}\n\n"
      original[:body].split("\n").each do |line|
      quoted = quoted + "> "+line + "\n"
      end
    quoted = quoted + "> ---------------------------------------------------------------------\n"
    return quoted
  end

    # Reply to a new message
  def reply(msgid)
    Tgtemplate.display('msgarea_confirm_postreply.ftl')
    if Tgio::Input::inputyn == true
      original = @areadb[:msgs].where(:id=>msgid).first
      # See if the "RE: " has been prepended already, if not add it.
      unless original[:subject][0,4] == "RE: "
        subject = "RE: "+original[:subject]
      else
        subject = original[:subject]
      end

      Tgtemplate.display('msgarea_reply_include_original.ftl')
      if Tgio::Input::inputyn == true
        body = Tgio::Tgedit::edit(quote(original))
      else
        body = Tgio::Tgedit::edit
      end

      # TODO : Enable error checking via try/catch  (same as 'post')
      unless body == nil
        #TODO: Ask user to confirm they are happy with the post before saving
        msg = @areadb[:msgs]
        msg.insert(:msgarea_id => @areameta[:id],
                   :from_id => $session.user_id,
                   :from => $session.username,
                   :subject => subject,
                   :body => body,
                   :composed => Time.now
                )

      end
      Tgtemplate.display('msgarea_post_success.ftl')
    end
  end

  # Allows a user to navigate (read) message area.
  def browse
    done = false
    validkeys=['?','J','L','P','R','S','V',']','[','X','1','0']
    msgindex = 0
    msglist = @areadb[:msgs].map(:id).reverse
    # If the msglist is empty, the reader will crash, so we either ask user to post or quit
    if msglist.empty? == true
      Tgtemplate.display('msgarea_empty.ftl')
      post
      return 0
    end

    # Start with most recent post first
    curmsg = msglist.first
    Tgtemplate.display('menu_msgarea_browser.ftl')
    until done == true
      msglist = @areadb[:msgs].map(:id).reverse
      msgcount = msglist.count
      msgmeta = @areadb[:msgs].where(:id => curmsg).first
      key = Tgio::Input.menuprompt('menu_msgarea_summary.ftl',validkeys, {"msgnum" => msgmeta[:id].to_s, "subject" => msgmeta[:subject].to_s, "msgdate" => msgmeta[:composed].to_s})
      print "\n"
      case key
        when 'V' # View message
          view(msgmeta)
        when 'R' # Reply
          reply(curmsg)
        when ']' # Goto Next
          if msgindex > (msgcount - 2)
            msgindex = 0
          else
            msgindex += 1
          end
          curmsg = msglist.at(msgindex)

        when '[' # Goto Previous
          if msgindex <= (0)
            msgindex = (msglist.count - 1)
          else
            msgindex -= 1
          end
          curmsg = msglist.at(msgindex)

        when 'P' # Post new message in area
          post
        when 'L' # List Messages
          listall
        when 'J' # Jump to messages Num
          Tgtemplate.display('msg_jumpto.ftl', nil)
          jumper = Tgio::Input::inputform(4).to_i
          # Validate input for correctness before switching areas
          if msglist.include?(jumper) == true
            curmsg = jumper
          else
            Tgtemplate.display('msg_jumpto_invalid.ftl', nil)
          end

        when '1' # Goto First Message in Area
          curmsg = msglist.last  # yes this is ''last'' because we get the msglist in reverse sorting
        when '0' # Goto Last Message in Area
          curmsg = msglist.first # yes this is ''first'' because we get the msglist in reverse sorting
        when '?'
          Tgtemplate.display('menu_msgarea_browser.ftl')
        when 'S'
          Telegard.unimplemented
        when 'X'
          done=true
          uninitialize
      end

    end
  end

  

end
