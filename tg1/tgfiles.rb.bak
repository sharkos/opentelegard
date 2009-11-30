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

 Source File: tgfiles.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: File Areas


---[ Changelog ]-------------------------------------------------------------



---[ TODO Items ]------------------------------------------------------------

=end
#

## NOTE: This is NOT the same class as ruby's File, do not confuse
class Files

def initialize
cfg = TGconfig.new
		@cfgin = cfg.load
end # END DEF INITIALIZE


##---------------------------------------------------------------------------
# File Manager
#
##---------------------------------------------------------------------------
def manager(curarea, area_name)

dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

	i = 0	# Array iterator

	submenuloop = 1
	while submenuloop > 0


		fileindex = dbc.select_all("SELECT fileid FROM files WHERE areaid='#{curarea}' ORDER BY fileid;")
		filenames = dbc.select_all("SELECT filename FROM files WHERE areaid='#{curarea}' ORDER BY filename;")
		totalfiles = fileindex.length
		lastfile = totalfiles - 1
		curfile = fileindex[i]
		viewindex = i + 1
	# Get current file data
		dbquery = dbc.execute("SELECT  * FROM files WHERE fileid = '#{curfile}';")
		 while row = dbquery.fetch do
     			file_id 			= row['fileid']
				area_id			= row['areaid']
				cat_id 			= row['catid']
				platform_id		= row['platform']
				owner_id 		= row['owner']
				file_name		= row['filename']
				file_descr		= row['description']
				file_checksum	= row['checksum']
				file_version	= row['version']
				crc_match		= row['crcmatch']
				file_added		= row['added']
   		end
		dbquery.finish

		area_path = dbc.select_one("SELECT path FROM fileareas WHERE areaid='#{area_id}'")
		filepath = "#{area_path}/#{file_name}"

		unless cat_id.nil?
		dbquery = dbc.execute("SELECT name FROM filecategories WHERE catid='#{cat_id}'")
			while row = dbquery.fetch do			
				cat_name = row['name']
			end
		dbquery.finish
		end

		unless platform_id.nil?
		dbquery = dbc.execute("SELECT name FROM platforms WHERE osid='#{platform_id}'")
			while row = dbquery.fetch do	
				platform_name = row['name']
			end
		dbquery.finish
		end

		unless owner_id.nil?
		dbquery = dbc.execute("SELECT login FROM users WHERE uid='#{owner_id}'")
			while row = dbquery.fetch do
				owner_name = row['login']
			end
		dbquery.finish
		end

	 	newvalue = "" # clear the newvalue variable each loop
		submenu = Ncurses.newwin(23,78,2,1)
		submenu.attron(Ncurses.COLOR_PAIR(8))
		submenu.box(0,0)
	   submenu.mvhline(2,1,0,76)
	   submenu.mvhline(20,1,0,76)
	   submenu.mvhline(17,1,0,76)
		submenu.attroff(Ncurses.COLOR_PAIR(1))
		submenu.clear
	 	submenu.attron(Ncurses.COLOR_PAIR(5))
	 	submenu.attron(Ncurses.COLOR_PAIR(7))
		clearline = " " * 76
		submenu.mvaddstr(1, 1, "#{clearline}")
	 	submenu.mvaddstr(1, 3, "File Manager - (area: #{area_name})")
	 	submenu.mvaddstr(1, 65, "[#{curfile} / #{totalfiles}]")
	 	submenu.attroff(Ncurses.COLOR_PAIR(7))
	 	submenu.attron(Ncurses::A_BOLD)
		submenu.attron(Ncurses.COLOR_PAIR(5))
		submenu.attroff(Ncurses.COLOR_PAIR(5))
 		submenu.attron(Ncurses.COLOR_PAIR(1))
		submenu.mvaddstr(3,2, "File DB ID#:")
		submenu.mvaddstr(3,20, "Date Added:")
		submenu.mvaddstr(4,2, "0. Filename:")
		submenu.mvaddstr(5,2, "1. Owner   :")
		submenu.mvaddstr(6,2, "2. Category:")
		submenu.mvaddstr(7,2, "3. Platform:")
		submenu.mvaddstr(8,2, "4. Version :")
		submenu.mvaddstr(9,2, "5. Checksum:")
		submenu.mvaddstr(10,2, "6. Summary :")

		submenu.mvaddstr(18,2,"]. Next File")
		submenu.mvaddstr(19,2,"[. Prev File")

		submenu.mvaddstr(18,18, ">. Next Area")
		submenu.mvaddstr(19,18, "<. Prev Area")

		submenu.mvaddstr(18,34, "C. Fix Checksum")
		submenu.mvaddstr(19,34, "-. Delete File")

		submenu.mvaddstr(18,51, "S. Search")

 		submenu.attroff(Ncurses.COLOR_PAIR(1))

		# display menu prompt
	 	submenu.attron(Ncurses.COLOR_PAIR(6))
	   submenu.mvaddstr(21, 2, "Selection [0-9,A-X] :")
	   submenu.attroff(Ncurses.COLOR_PAIR(6))

    	submenu.attron(Ncurses.COLOR_PAIR(3))
		submenu.mvaddstr(3, 15, "#{file_id}")					unless file_id.nil?
		submenu.mvaddstr(3, 32, "#{file_added}")					unless file_added.nil?
		submenu.mvaddstr(4, 15, "#{file_name}")				unless file_name.nil?
		submenu.mvaddstr(5, 15, "#{owner_name.upcase} (#{owner_id})")	unless owner_name.nil?
		submenu.mvaddstr(6, 15, "#{cat_name.capitalize}")	unless cat_name.nil?
		submenu.mvaddstr(7, 15, "#{platform_name}")			unless platform_name.nil?
		submenu.mvaddstr(8, 15, "#{file_version}")			unless file_version.nil?
		submenu.mvaddstr(9, 15, "#{file_checksum}")			unless file_checksum.nil?

		submenu.attron(Ncurses.COLOR_PAIR(5))
				submenu.mvaddstr(9, 50, "CRC: ")			
				submenu.attron(Ncurses.COLOR_PAIR(3))
		unless crc_match.nil?
			if crc_match == true

				submenu.mvaddstr(9, 55, "PASS")			
			else
				submenu.mvaddstr(9, 55, "FAIL")			
			end
		else
			submenu.mvaddstr(9, 55, "No Index Found")			
		end

		submenu.mvaddstr(10, 15, "#{file_descr}")				unless file_descr.nil?
    	submenu.attroff(Ncurses.COLOR_PAIR(3))

		submenu.attron(Ncurses.COLOR_PAIR(2))
		submenu.mvaddstr(21, 24, " ")
		submenu.mvaddstr(21, 24, "")
		submenu.refresh
		submenuitem = submenu.getch()
	   case submenuitem
			when 'x'[0], 'X'[0] # Exit
				submenuloop = 0
			when 'c'[0], 'C'[0] # Replace DB checksum with file's md5sum
				if File.exists?(filepath)
					fs_checksum = Digest::MD5.hexdigest(File.read(filepath))
					dbquery = dbc.execute("UPDATE files SET checksum = '#{fs_checksum}' WHERE fileid='#{curfile}';")
				dbquery.finish
				end

			when ']'[0] # Next FILE
				unless i >= lastfile
					i = i + 1 
				else
					i = 0
		 		end
		 		curfile = fileindex[i]
			when '['[0] # Prev FILE
		 		unless i <= 0
					i = i - 1 
		 		else
					i = lastfile
		 		end
		 		curfile = fileindex[i]
			# TODO: Disabling this feature for now
#			when 'm'[0], 'M'[0]	# MOVE FILE TO ANOTHER AREA
#				target = Fileareas.new
#				newarea = target.select(area_id)
		when '-'[0] # Delete File
			popuploop = 1
				while popuploop > 0
					popupmenu = Ncurses.newwin(6,74,12,2)
					popupmenu.box(0,0)
					popupmenu.clear
					popupmenu.mvaddstr(0,3, "[ Permanently Delete File ]")
 					popupmenu.attron(Ncurses.COLOR_PAIR(3))
		 	      popupmenu.attron(Ncurses::A_BOLD)
					popupmenu.mvaddstr(2,2, "This action will permanently delete this file. Are you sure?")
					popupmenu.mvaddstr(3,2, "#{filepath}")
					popupmenu.attron(Ncurses.COLOR_PAIR(6))
					popupmenu.mvaddstr(5, 63, "[y/n:   ]")
					popupmenu.attron(Ncurses.COLOR_PAIR(2))
	 				popupmenu.mvaddstr(5, 69, " ")
	 				popupmenu.mvaddstr(5, 69, "")
		 	      popupmenu.attroff(Ncurses::A_BOLD)
					popupmenu.refresh
						case(popupmenu.getch())
						 	when 'y'[0], 'Y'[0]
									if File.exists?(filepath)
										File.delete(filepath)
									end
									dbquery = dbc.execute("DELETE FROM files WHERE fileid = '#{file_id}';")
									dbquery.finish

								unless i <= 0  # When completed go to the previous file
									i = i - 1 
								else
									i = lastfile
								end
								popuploop = 0
				# We check if totalfiles = 1  because if we got to this point in our loop
				# The database query has not refreshed to recount. So a count of 1 at this
				# point will be zero in the next iteration. If that is the case, filemanager
				# will error out. So instead, end the filemanager as well.
								if totalfiles == 1 
									submenuloop = 0
								end
							when 'n'[0], 'N'[0]
								popuploop = 0
						end
				end # END WHILE
				popupmenu.delwin


		end # END CASE

	end # END WHILE
		submenu.delwin
end # END DEF MANAGER


end # END CLASS