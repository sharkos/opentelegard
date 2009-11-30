#!/usr/bin/env ruby
# 
=begin
                ===============================================
                              OpenTG BBS Project
                     Copyright (C) 2008 - 2009  Chris Tusa
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

 Source File: tgwho.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Functions related to current/recent callers 


---[ Changelog ]-------------------------------------------------------------



---[ TODO Items ]------------------------------------------------------------
 

=end
#
# ---[ Program Code Begins ]-------------------------------------------------


#
# Who file and related tools
#
class Who

end



#
# Database backended call history. Used for showing recent callers, and generating
# historical reports.
#
class CallHistory
 attr_accessor	:callnumber,
					:login,
					:city,
					:state,
					:timeon,
					:timeoff,
					:node

 def initialize
	cfg = TGconfig.new
	@cfgin = cfg.load
 end


# Add an entry to the call history table. It is preferred NOT to use relational 
# data here, as user information could change. Staticly inserted information is preferred
 def add(calldata) 
	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")
	# Have to translate these from the input due to SQL statement bug
	node = calldata['node']
	login = calldata['login']
	city = calldata['city']
	state = calldata['state']
	timeon = calldata['timeon']

	dbquery = dbc.execute("INSERT INTO 
callhistory(
				callnumber,
				node, 
				login, 
				city, 
				state, 
				timeon 
)
     VALUES(
				DEFAULT, 
				'#{node}', 
				'#{login}', 
				'#{city}',
				'#{state}',
				'#{timeon}'
) RETURNING callnumber;")
	while row = dbquery.fetch
		callnumber = row['callnumber']
	end
	dbquery.finish

	callnumber
 end


# Update call data when a user signs off. (fix TIMEOFF)
#
 def update(callnumber)
	timeoff = Time.now
	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")
	dbquery = dbc.execute("UPDATE callhistory SET timeoff='#{timeoff}' WHERE callnumber=#{callnumber}")
	timeoff
 end

 # show number of entries
 def show(num=@cfgin.recent_min)
	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")
	num = num.to_i
	ansiputs("Last #{num} callers to this system:\n", white)
	ansiputs("Alias                From               Login Time       Logout Time\n", yellow)
	ansiputs("-------------------- ------------------ ---------------- ----------------\n", black)
  	dbquery = dbc.execute("SELECT * FROM callhistory ORDER BY callnumber DESC LIMIT #{num};")
		while row = dbquery.fetch

			newtimeon = row['timeon'].to_s
			newtimeon = newtimeon.scan(/\w/)
			timeon = "#{newtimeon[0..3]}-#{newtimeon[4..5]}-#{newtimeon[6..7]}@#{newtimeon[9..10]}:#{newtimeon[11..12]}"

			newtimeoff = row['timeoff'].to_s
			newtimeoff = newtimeoff.scan(/\w/)
			timeoff = "#{newtimeoff[0..3]}-#{newtimeoff[4..5]}-#{newtimeoff[6..7]}@#{newtimeoff[9..10]}:#{newtimeoff[11..12]}"

			ansiputs("#{row['login']}", cyan)
			space = 20 - row['login'].length 
			print " " * space if space > 0
			space = 16 - (row['state'].length + row['city'].length)
			ansiputs("(#{row['city']}, #{row['state']})", cyan, false)
			print " " * space if space > 0
			ansiputs("#{timeon}\s", blue, false)
			ansiputs("#{timeoff}\n", blue, false)
		end
	dbquery.finish

 end

 # TODO: archive history - moves data to an archive table
 def archive
 end

end