=begin
               ================================================
                      OpenTelegard/2 Operating SubSystem
               Copyright (C) 2008-2011   LeafScale Systems, LLC
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

 Source File: /lib/controllers/help.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@telegard.org>
 Description: Help Menu controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= HelpController
The Help Menu controller.
=end

# Help Controller Class
class BBSlistController < Tgcontroller

  def menu
    done = false
    validkeys=['A','L','N','S','X']
    until done == true
      key = Tgio::Input.menuprompt('menu_bbslist.ftl',validkeys, nil) # nil is for tpl vars hash
      test_session
      print "\n"
      case key
        when "A" # Add to local directory
          if Tgio::Input::inputyn('bbslist_askstart.ftl') == true
            self.add
          end
        when "L" # List local directory
          bbslist = Tgtemplate::Template.parse_dataset($db[:bbslist].all)
          Tgtemplate.display('bbslist_list_local.ftl', {'bbslist' => bbslist})
        when "N" # Network Lookup
          Telegard.unimplemented
        when "S" # Search
          Telegard.unimplemented

        when "X" # Return to Main
          done = true          
      end #/case
      test_session
    end #/until
    return 0
  end #/def menu

  # Adds an entry to the local bbs list.
  def add
     listdata = { 'bbsname' => askbbsname,
                  'description' => askdescription,
                  'sysopname' => asksysopname,
                  'bbsurl' => askbbsurl,
                  'homepage' => askhomepage }
     done = false
     validkeys=['B','D','H','S','U','X','.']
     until done == true
       key = Tgio::Input.menuprompt('bbslist_confirmadd.ftl',validkeys, listdata) # nil is for tpl vars hash
       print "\n"
       case key
         when "B" # BBS Name
           listdata['bbsname'] = askbbsname
         when "D" # Description
           listdata['description'] = askdescription
         when "H" # Homepage
           listdata['homepage'] = askhomepage
         when "S" # Sysop Name
           listdata['sysopname'] = asksysopname
         when "U" # URL
           listdata['bbsurl'] = askbbsurl
         when "." # Quit NO SAVE
           return 0
         when "X" # Quit + SAVE
           Tgbbslist.create(
                   :bbsname => listdata['bbsname'],
                   :description => listdata['description'],
                   :sysopname => listdata['sysopname'],
                   :bbsurl => listdata['bbsurl'],
                   :homepage => listdata['homepage'],
                   :submitted_by => $session.username,
                   :created => Time.now 
                   )
           return 0

       end
     end
  end #/def add

  private
  # Input: BBS Name
  # TODO: Check for duplicates.
  def askbbsname(val=nil)
      complete = false
      until complete == true
        bbsname = Tgio::question('bbslist_askbbsname.ftl', 30)
        unless bbsname.is_blank? || bbsname.minlength?(3) == false
          complete = true if bbsname.is_spaced_alphanumeric?
        end #/if
      end #/until
      return bbsname
    end #/def askbbsname

  # Input: BBS Description
  def askdescription
    complete = false
    until complete == true
      description = Tgio::question('bbslist_askdescription.ftl', 75)
      unless description.is_blank? || description.minlength?(3) == false
        complete = true
      end #/if
    end #/until
    return description
  end #/def askbbsdescription

  # Input: BBS Sysop Name
  def asksysopname(val=nil)
      complete = false
      until complete == true
        sysopname = Tgio::question('bbslist_asksysop.ftl', 30)
        unless sysopname.is_blank? || sysopname.minlength?(3) == false
          complete = true if sysopname.is_spaced_alphanumeric?
        end #/if
      end #/until
      return sysopname
    end #/def asksysopname

  # Input: BBS Homepage - where information about the BBS can be found online
  def askhomepage(val=nil)
      complete = false
      until complete == true
        homepage = Tgio::question('bbslist_askhomepage.ftl', 75)
        # Homepage can be Optional, so either allow blank or validurl
        if homepage.is_blank? || homepage.is_url? == true
          complete = true
        end #/if
      end #/until
      return homepage
    end #/def askhomepage

  # Input: BBS URL - Connection url (ssh://opentg:opentg@alpha.telegard.org)
  def askbbsurl
      complete = false
      until complete == true
        bbsurl = Tgio::question('bbslist_askbbsurl.ftl', 75)        
        unless bbsurl.is_blank? || bbsurl.minlength?(10) == false
          complete = true
        end #/if
      end #/until
      return bbsurl
    end #/def askbbsurl


end