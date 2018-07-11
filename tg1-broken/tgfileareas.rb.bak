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

 Source File: tgfileareas.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: File Areas


---[ Changelog ]-------------------------------------------------------------



---[ TODO Items ]------------------------------------------------------------

=end
#

class Fileareas

attr_accessor :area_id, :area_name, :area_descr, :area_path, :area_moderator,
	:area_group, :allow_writes, :area_autoindex, :area_password, :allow_read,
	:usersearch, :numfiles

def initialize
		cfg = TGconfig.new
		@cfgin = cfg.load
		numfiles = 0
end #END DEF


## Admin File Areas
def cfgeditor

	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

	i = 0	# Array iterator
	submenuloop = 1
	while submenuloop > 0

		areaindex = dbc.select_all "SELECT areaid FROM fileareas ORDER BY areaid;"
		totalareas = areaindex.length
		lastarea = totalareas - 1
		curarea = areaindex[i]
		viewindex = i + 1

		# Get current area data
		dbquery = dbc.execute "SELECT  * FROM fileareas WHERE areaid = '#{curarea}';"
		 while row = dbquery.fetch do
     			area_id 			= row['areaid']
				area_name 		= row['name']
				area_descr 		= row['description']
				area_path		= row['path']
				area_password	= row['password']
				area_moderator	= row['moderator']
				area_mingid 	= row['mingid']
				area_autoindex = row['autoindex']
				area_write 	= row['write']
				area_read		= row['read']
				area_lastindex	= row['lastindex']
   		end
		dbquery.finish

		dbquery = dbc.execute "SELECT COUNT(*) FROM files WHERE areaid = '#{curarea}';"
		 while row = dbquery.fetch do
			numfiles = row[0]
		 end
		dbquery.finish
		numfiles = numfiles.to_i

		row = dbc.select_one "SELECT login FROM users WHERE uid = '#{area_moderator}'"
			moderator_name = row[0]

		row = dbc.select_one "SELECT name FROM groups WHERE gid = '#{area_mingid}'"
			mingid_name = row[0]

		# TODO: Check if dir exists & permissions OK, otherwise display warning on menu

		# /* START FILE AREA MENU */
	 	newvalue = "" # clear the newvalue variable each loop
		submenu = Ncurses.newwin(23,78,2,1)
		submenu.attron(Ncurses.COLOR_PAIR(8))
		submenu.box(0,0)
	   submenu.mvhline(2,1,0,76)
	   submenu.mvhline(5,1,0,76)
	   submenu.mvhline(20,1,0,76)
		submenu.attroff(Ncurses.COLOR_PAIR(1))
		submenu.clear
	 	submenu.attron(Ncurses.COLOR_PAIR(5))
	 	submenu.attron(Ncurses.COLOR_PAIR(7))
		clearline = " " * 76
		submenu.mvaddstr(1, 1, "#{clearline}")
	 	submenu.mvaddstr(1, 3, "File Areas Editor \t\t\t\t\tViewing [#{viewindex} / #{totalareas}]")
	 	submenu.attroff(Ncurses.COLOR_PAIR(7))
	 	submenu.attron(Ncurses::A_BOLD)
		# /* MEMBERS COLOR OFFSET */
		submenu.attron(Ncurses.COLOR_PAIR(5))
		submenu.mvaddstr(3,35, "Files:")
		submenu.attroff(Ncurses.COLOR_PAIR(5))
 		submenu.attron(Ncurses.COLOR_PAIR(1))
		submenu.mvaddstr(3,2, "0. Area :")
		submenu.mvaddstr(3,67,"ID#:")
		submenu.mvaddstr(4,2, "1. Descr:")
		submenu.mvaddstr(6,2, "   Last Index :")
		submenu.mvaddstr(7,2, "2. Moderator  :")
		submenu.mvaddstr(8,2, "3. Min Group  :")
		submenu.mvaddstr(9,2, "4. Storage Dir:")
		submenu.mvaddstr(10,2, "5. Autoindex  :")
		submenu.mvaddstr(11,2,"6. Allow Write:")
		submenu.mvaddstr(12,2,"7. Allow Read :")
		submenu.mvaddstr(13,2,"8. Password   :")
#		submenu.mvaddstr(12,2,"9.    :")
#		submenu.mvaddstr(13,2,"A.  :")
#		submenu.mvaddstr(14,2,"B.  :")
#		submenu.mvaddstr(15,2,"C.  :")
#		submenu.mvaddstr(16,2,"D.  :")

	   submenu.mvhline(17,1,0,76)
		submenu.mvaddstr(18,2,"]. Next Area")
		submenu.mvaddstr(19,2,"[. Prev Area")
		submenu.mvaddstr(18,20, "+. Add new area")
		submenu.mvaddstr(19,20, "-. Delete area")

		submenu.mvaddstr(18,38, "!. File Manager")
		submenu.mvaddstr(19,38, "@. Index Now")
		submenu.mvaddstr(18,59, "%. Remove Passwd")
		submenu.mvaddstr(19,59, "X. Exit Editor")

		

 		submenu.attroff(Ncurses.COLOR_PAIR(1))

		# display menu prompt
	 	submenu.attron(Ncurses.COLOR_PAIR(6))
	   submenu.mvaddstr(21, 2, "Selection [0-9,A-X] :")
	   submenu.attroff(Ncurses.COLOR_PAIR(6))

    	submenu.attron(Ncurses.COLOR_PAIR(3))
		submenu.mvaddstr(3, 12, "#{area_name.upcase}")	unless area_name.nil?
		submenu.mvaddstr(3, 42, "#{numfiles}")		unless numfiles.nil?
		submenu.mvaddstr(3, 72, "#{curarea}") 					unless curarea.nil?
	 	submenu.mvaddstr(4, 12, "#{area_descr}") 				unless area_descr.nil?
	 	submenu.mvaddstr(6, 18, "#{area_lastindex}")			unless area_lastindex.nil?
	 	submenu.mvaddstr(7, 18, "#{moderator_name.upcase} (#{area_moderator})") 		unless area_moderator.nil?
	 	submenu.mvaddstr(8, 18, "#{mingid_name.upcase} (#{area_mingid})") 			unless area_mingid.nil?
	 	submenu.mvaddstr(9, 18, "#{area_path}") 				unless area_path.nil?
	 	submenu.mvaddstr(10, 18, "#{area_autoindex}") 		unless area_autoindex.nil?
	 	submenu.mvaddstr(11,18, "#{area_write}") 			unless area_write.nil?
	 	submenu.mvaddstr(12,18, "#{area_read}") 				unless area_read.nil?
	   unless area_password.nil?
		# TODO: Determine if PW'd are shown in plaintext or hidden
				submenu.mvaddstr(13,18, "%%%%%%%%%%%%%%%")
		else
				submenu.mvaddstr(13,18, "-NOT SET-")
		end # end unless
    	submenu.attroff(Ncurses.COLOR_PAIR(3))

		submenu.attron(Ncurses.COLOR_PAIR(2))
		submenu.mvaddstr(21, 24, " ")
		submenu.mvaddstr(21, 24, "")
		submenu.refresh
		submenuitem = submenu.getch()
	   case submenuitem
			when 'x'[0], 'X'[0] # Exit
				submenuloop = 0
			when '%'[0] # Remove File Area Password
				dbquery = dbc.execute("UPDATE fileareas SET password = NULL WHERE areaid = '#{curarea}'")
				dbquery.finish
			when '!'[0]	# File Manager
				if numfiles > 0
				fileadmin = Files.new
				fileadmin.manager(curarea, area_name)
				end
			when ']'[0] # Next AREA
				unless i >= lastarea
					i = i + 1 
				else
					i = 0
		 		end
		 		curuid = areaindex[i]
			when '['[0] # Prev AREA
		 		unless i <= 0
					i = i - 1 
		 		else
					i = lastarea
		 		end
		 		curarea = areaindex[i]
			when '-'[0] # Delete Area
				unless "#{curarea}" == "1" # cannot delete the first area - its required
				popuploop = 1
					while popuploop > 0
						popupmenu = Ncurses.newwin(5,54,10,12)
						popupmenu.box(0,0)
						popupmenu.clear
						popupmenu.mvaddstr(0,3, "[ Confirm Area Delete ]")
 						popupmenu.attron(Ncurses.COLOR_PAIR(3))
		 	      	popupmenu.attron(Ncurses::A_BOLD)
						popupmenu.mvaddstr(2,2, "Are you sure? Delete this area from database now?")
						popupmenu.mvaddstr(3,2, "You will need to remove #{numfiles} files manually")
						popupmenu.attron(Ncurses.COLOR_PAIR(6))
						popupmenu.mvaddstr(4, 43, "[ y/N:  ]")
						popupmenu.attron(Ncurses.COLOR_PAIR(2))
	 					popupmenu.mvaddstr(4, 50, " ")
	 					popupmenu.mvaddstr(4, 50, "")
		 	      	popupmenu.attroff(Ncurses::A_BOLD)
						popupmenu.refresh
						case(popupmenu.getch())
						 	when 'y'[0], 'Y'[0]
								dbquery = dbc.execute "DELETE FROM fileareas WHERE areaid = '#{curarea}';"
								dbquery.finish
								unless i <= 0  # When completed go to the previous area
									i = i - 1 
								else
									i = lastarea
								end
								popuploop = 0
							when 'n'[0], 'N'[0]
								popuploop = 0
						end # END CASE
					end # END WHILE
					popupmenu.delwin
				end # END UNLESS
			when '+'[0] # Add new Area
				# Adding simply adds a blank entry with the next available areaid
				idx = 0
				sdx = 1 
				scanids = []
				availids = []
				areaindex.each do |idvalue|
					scanids << "#{idvalue}"
					unless scanids[idx].to_i == sdx
						availids << sdx
					end
					sdx = sdx + 1
					idx = idx +1
				end
				# If the sequential ID check turns out nil, we add one to the end
				unless availids.empty?
					newid = availids[0]
				else
					newid = totalareas + 1
				end
				# SET SOME DEFAULTS FOR NEW AREAS
				default_name 		= "NEWAREA-#{newid}"
				default_descr		= "Newly Created File Area #{newid}"
				default_path		= "#{@cfgin.path_fileareas}/#{newid}"
				moderator_name = row[0]

				default_moderator	= 1
				default_mingid		= 1
				default_autoindex = "FALSE"
				default_write 		= "FALSE"
				default_read		= "TRUE"
	
				# populate default perms for new file area creation
				dbquery = dbc.execute("INSERT INTO fileareas(areaid, name, description,	path, moderator, mingid, autoindex, write, read) VALUES(#{newid}, '#{default_name}', '#{default_descr}', '#{default_path}', #{default_moderator}, #{default_mingid}, #{default_autoindex}, #{default_write}, #{default_read});")
				dbquery.finish
				i = newid - 1
			when '@'[0] # Run Index
#				unless numfiles < 1
					indexprog = Fileindex.new
					indexprog.scan(curarea)
#				end

			when '0'[0] # Area Name
				 clearline = " " * 16
				 submenu.mvaddstr(3, 12, "#{clearline}")
				 submenu.move(3,12)
		  		 submenu.getstr(newvalue)
					unless newvalue.empty?
					area_name = newvalue
					dbquery = dbc.execute("UPDATE fileareas SET name = '#{area_name}' WHERE areaid = '#{curarea}';")
					dbquery.finish
					end
			when '1'[0] # Description
				 clearline = " " * 58
				 submenu.mvaddstr(4, 12, "#{clearline}")
				 submenu.move(4,12)
		  		 submenu.getstr(newvalue)
					unless newvalue.empty?
					area_descr = newvalue
					dbquery = dbc.execute("UPDATE fileareas SET description = '#{area_descr}' WHERE areaid = '#{curarea}'")
					dbquery.finish
					end
			when '2'[0] # Moderator UID 
					usersearch = User.new
					results = usersearch.find('login')

					unless results.nil? 
					if results.length > 1
					#TODO: POP BOX - ask for user's login name and then search for validity
					popuploop = 1
					while popuploop > 0
						popupmenu = Ncurses.newwin(9,34,8,18)
 						popupmenu.attron(Ncurses.COLOR_PAIR(3))
						popupmenu.box(0,0)
						popupmenu.clear
						popupmenu.mvaddstr(0,3, "[                  ]")
						popupmenu.attron(Ncurses.COLOR_PAIR(5))
						popupmenu.mvaddstr(0,5, "RESULTS")
		 	      	popupmenu.attron(Ncurses::A_BOLD)
						popupmenu.attron(Ncurses.COLOR_PAIR(2))
						ncrow = 1
						results.each do |result|
						  popupmenu.mvaddstr(ncrow,2, "#{results}")
						  ncrow = ncrow + 1
						end

						popupmenu.refresh
						popupmenu.getch
						popupmenu.refresh
						popuploop = 0

					end # END WHILE
					popupmenu.delwin
					end # END IF
					dbquery = dbc.execute("UPDATE fileareas SET moderator = '#{results[0]}' WHERE areaid = '#{curarea}';")
					
				end # END UNLESS

			when '3'[0] # Minimum GID
				newgid = Group.new
				area_mingid = newgid.select(area_mingid)
				#TODO: Better dummy checks here
				dbquery = dbc.execute("UPDATE fileareas SET mingid = '#{area_mingid}' WHERE areaid = '#{curarea}'")
					dbquery.finish

			when '4'[0] # Path
			 clearline = " " * 58
				 submenu.mvaddstr(8, 18, "#{clearline}")
				 submenu.move(8,18)
				 oldpath = area_path
		  		 submenu.getstr(newvalue)
					unless newvalue.empty?
						area_path = newvalue
						dbquery = dbc.execute("UPDATE fileareas SET path = '#{area_path}' WHERE areaid = '#{curarea}'")
						dbquery.finish

						#TODO: Catch problems with directory missing errors, etc

						# Check if exists and rename to new path if changed
						if File.exists?(oldpath) && File.directory?(oldpath)
							File.rename(oldpath, area_path)
						else # otherwise create an empty dir
							Dir.mkdir(area_path)
						end # END IF
					end # END UNLESS

			when '5'[0] # Autoindex
				if area_autoindex == true
					area_autoindex = false
				else
					area_autoindex = true
				end 
				dbquery = dbc.execute("UPDATE fileareas SET autoindex = #{area_autoindex} WHERE areaid = '#{curarea}'")
				dbquery.finish

			when '6'[0] # Allow Uploads
				if area_write == true
					area_write = false
				else
					area_write = true
				end 
				dbquery = dbc.execute("UPDATE fileareas SET write = #{area_write} WHERE areaid = '#{curarea}'")
				dbquery.finish

			when '7'[0] # Allow Reads
				if area_read == true
					area_read = false
				else
					area_read = true
				end 
				dbquery = dbc.execute("UPDATE fileareas SET read = #{area_read} WHERE areaid = '#{curarea}'")
				dbquery.finish
			when '8'[0] # Area Name
				 clearline = " " * 16
				 submenu.mvaddstr(12, 18, "#{clearline}")
				 submenu.move(12,18)
		  		 submenu.getstr(newvalue)
					unless newvalue.empty?
						cryptpw = Password.new
						area_password = cryptpw.crypt(newvalue)
						dbquery = dbc.execute("UPDATE fileareas SET password = '#{area_password}' WHERE areaid = '#{curarea}';")
						dbquery.finish
					end
			end # END CASE
		end # END WHILE

end # END DEF


# File Area Select Menu
def select(curarea)

 	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
									 "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

		# Get total number of area
		dbquery = dbc.execute "SELECT COUNT(areaid) FROM fileareas"
			while row = dbquery.fetch do
				totalareas = row[0]
			end
		dbquery.finish

		rows = dbc.execute "SELECT areaid, name FROM fileareas ORDER BY areaid"
			while row = dbquery.fetch do
					
			end


		dbquery.finish
			areaselect = 1		# Start showing at the first areaid
			showmax = 5			# Show a max of N in the menu list scroll
			popuploop = 1
				while popuploop > 0
					ncrow = 1
					ncstartcol = 2
					popupmenu = Ncurses.newwin(8,45,7,16)
					popupmenu.box(0,0)
					popupmenu.clear
					popupmenu.mvaddstr(0,3, "[ Select New Area ]")
 					popupmenu.attron(Ncurses.COLOR_PAIR(3))
		 	      popupmenu.attron(Ncurses::A_BOLD)
					ncrow = 2
					while count <= showmax
						areaitem = arealist[count]
						popupmenu.mvaddstr(ncrow,3, "#{areaitem}")
						count = count + 1
						ncrow = ncrow + 1
					end
					
					popupmenu.attron(Ncurses.COLOR_PAIR(6))
					#popupmenu.mvaddstr(12, 2, "[1-#{totalareas}, X:   ]")
					popupmenu.attron(Ncurses.COLOR_PAIR(2))
	 				#popupmenu.mvaddstr(12, 11, " ")
	 				#popupmenu.mvaddstr(12, 11, "")
		 	      popupmenu.attroff(Ncurses::A_BOLD)
					popupmenu.refresh
						case(popupmenu.getch())
							when 'x'[0], 'X'[0]
								areaid = curarea
								popuploop = 0
						end
				end # End popupmenuloop while
				popupmenu.delwin
				return areaid
end # end def 

end # END CLASS
