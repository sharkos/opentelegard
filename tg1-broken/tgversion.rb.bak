#!/usr/bin/env ruby
# 
=begin
                ===============================================
                              OpenTG BBS Project
                        Copyright (C) 2008  Chris Tusa
                http://www.opentg.org | telnet://bbs.opentg.org
                ===============================================


---[ License & Distribution ]------------------------------------------------

OpenTG is distributed under the GNU General Public License version 3 (GPLv3)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


---[ File Info ]-------------------------------------------------------------

 Source File: tgversion.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: OpenTG Version Information and Handlers


---[ Changelog ]-------------------------------------------------------------

 
---[ TODO Items ]------------------------------------------------------------
 

=end
#
# ---[ Program Code Begins ]-------------------------------------------------

## Define Program Constants
TGversion = {
				"shortname" => "opentg", 
				"longname" 	=> "OpenTelegard BBS", 
				"version" 	=> 0.2, 
				"author" 	=> "Chris Tusa",
				"contact"	=> "<chris.tusa@opentg.org", 
				"vendor" 	=> "www.opentg.org", 
				"copyright" => "(C) 2009",
				"license" => "GNU GPL v3"
}


#
# Class to handle posting of BBS information
#
class TGbbsinfo

 def initialize
	cfg = TGconfig.new
	@cfgin = cfg.load
  
   # get some stats here
   dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

	@totalcalls = dbc.select_one("SELECT max(callnumber) FROM callhistory;")
	@totalusers = dbc.select_one("SELECT COUNT(uid) FROM users;")
   @sysopalias = dbc.select_one("SELECT login FROM users WHERE uid = 1;")

 end

 def out


    ansiputs("\n----------------[ ",blue,false)
    ansiputs("About #{@cfgin.bbs_name}", cyan, false)
    ansiputs(" ]----------------\n", blue, false)

 
    ansiputs("Location   : ", magenta, false)
    ansiputs("#{@cfgin.bbs_city}, #{@cfgin.bbs_state} (#{@cfgin.bbs_country})\n", yellow)

    ansiputs("BBS URL    : ", magenta, false)
    ansiputs("#{@cfgin.bbs_consoleurl}\n", yellow)

    ansiputs("SysOP Alias: ", magenta, false)
    ansiputs("#{@sysopalias.to_s.upcase}\n", yellow)

    ansiputs("Total Calls: ", magenta, false)
    ansiputs("#{@totalcalls}\n", yellow)

    ansiputs("Total Users: ", magenta, false)
    ansiputs("#{@totalusers}\n", yellow)

    print "\n"

   HighLine.color_scheme = Tgcolors01
   say("<%= color('#{TGversion['shortname']}', :title) %> <%= color(':', :bracket) %> <%= color('#{TGversion['longname']} v#{TGversion['version']}', :text) %> <%= color('(', :bracket) %> <%= color('Ruby v#{RUBY_VERSION}', :text) %> <%= color(')', :bracket) %> <%= color('-', :bracket) %> <%= color('Released under #{TGversion['license']}', :title) %>\n<%= color('#{TGversion['copyright']} #{TGversion['author']} - #{TGversion['vendor']}', :title)%>")

    print "\n"
    pause
 end

end
