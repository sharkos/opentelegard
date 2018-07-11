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

 Source File: tgfileindexer.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Handles file indexing for fileareas


---[ Changelog ]-------------------------------------------------------------



---[ TODO Items ]------------------------------------------------------------

 * Items are embedded

=end
#


class Fileindex

def initialize
	cfg = TGconfig.new
	@cfgin = cfg.load
	@missing 	= 0
	@found 		= 0
	@md5fail 	= 0
end


def scan(curarea)


dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

		dbquery = dbc.execute "SELECT areaid, name, description, path, moderator, autoindex FROM fileareas WHERE areaid = '#{curarea}';"
		 while row = dbquery.fetch do
     			area_id 			= row['areaid']
				area_name 		= row['name']
				area_descr 		= row['description']
				area_path		= row['path']
				area_moderator	= row['moderator']
				area_autoindex = row['autoindex']
   		end
		dbquery.finish

	popup = Ncurses.newwin(6,54,10,12)
	popup.box(0,0)
	popup.clear
	popup.mvaddstr(0,3, "[ Indexing #{area_name} ]")
	popup.attron(Ncurses.COLOR_PAIR(3))
  	popup.attron(Ncurses::A_BOLD)
   clearline = " " * 50
	popup.attron(Ncurses.COLOR_PAIR(5))
	popup.mvaddstr(1,2, "#{clearline}")
	popup.refresh


		# Retrieve into an array a listing of all filenames to use for comparison
		db_filenames = []
		dbquery = dbc.execute("SELECT filename FROM files WHERE areaid='#{curarea}' ORDER BY filename;")
		while row = dbquery.fetch do
			db_filenames << row[0]
		end # end while


		if File.exists?(area_path) && File.directory?(area_path)
			dir_filenames = Dir.entries(area_path)
		else
			popup.mvaddstr(3,2,"ERROR: #{area_path} does not exist.")
			popup.attron(Ncurses.COLOR_PAIR(1))
			popup.attron(Ncurses::A_REVERSE)
			popup.mvaddstr(5,22,"[CLOSE]")	
			popup.move(5,26)
			popup.refresh
			popup.getch()
			popup.delwin
			return 1 # Stop here if area's directory doesn't exist
		end

	# PHASE 2.1: Compare local files to database first (find new)
	dir_filenames.each do |file|
		filepath = "#{area_path}/#{file}"
		unless File.directory?(filepath)
		if db_filenames.include?(file)
			fs_checksum = Digest::MD5.hexdigest(File.read(filepath))
			db_checksum = dbc.select_one("SELECT checksum FROM files WHERE filename='#{file}';")
			if "#{fs_checksum}" == "#{db_checksum}"
				crcmatch = true
			else
				@md5fail = @md5fail + 1
				crcmatch = false
			end
				dbquery = dbc.execute("UPDATE files SET crcmatch=#{crcmatch} WHERE filename='#{file}'")
				dbquery.finish
		else
			@found = @found + 1
			#TODO: Gather File Information and Plug into Database (nf means newfile)
			nf_name 		= file
			nf_date 		= File.mtime(filepath)
			nf_size 		= File.size(filepath)
			nf_checksum = Digest::MD5.hexdigest(File.read(filepath))
			nf_owner		= 1
			timestamp 	= Time.now		

			dbquery = dbc.execute("
INSERT INTO files(fileid, areaid,
				filename,
				size,
				date,
				owner,
				checksum,
				added,
				crcmatch) VALUES(DEFAULT,
									'#{curarea}',
									'#{nf_name}',
									'#{nf_size}',
									'#{nf_date}',
									#{nf_owner},
									'#{nf_checksum}',
									'#{timestamp}',
									TRUE)
")
			dbquery.finish

		end # end if
		end # end unless
	end


	# PHASE 2.2: Compare database to local files (find missing)
	db_filenames.each do |file|
		filepath = "#{area_path}/#{file}"
		# Delete files that are IN DB, but not FS
		unless File.exists?(filepath)
			@missing = @missing + 1
			dbquery = dbc.execute("DELETE FROM files WHERE filename='#{file}'")
		end
	end

# Add Timestamp to File Area on lastindex
	timestamp = Time.now
	dbquery = dbc.execute("UPDATE fileareas SET lastindex='#{timestamp}' WHERE areaid='#{curarea}'")

# Print Index Summary
popup.mvaddstr(2,2,"Files Added: #{@found}") 
popup.mvaddstr(3,2,"DB Removed : #{@missing}")
popup.mvaddstr(4,2,"MD5 Failed : #{@md5fail}")
popup.attron(Ncurses.COLOR_PAIR(1))
popup.attron(Ncurses::A_REVERSE)
popup.mvaddstr(5,22,"[CLOSE]")	
popup.move(5,26)
popup.refresh
popup.getch()
popup.delwin
return 0
end #def scan

end #class

=begin
# FOR TESTING ONLY
Ncurses.initscr		
Ncurses.start_color
Ncurses.init_pair(1, Ncurses::COLOR_BLUE, Ncurses::COLOR_BLACK)
Ncurses.init_pair(2, Ncurses::COLOR_YELLOW, Ncurses::COLOR_BLUE)
Ncurses.init_pair(3, Ncurses::COLOR_CYAN, Ncurses::COLOR_BLACK)
Ncurses.init_pair(4, Ncurses::COLOR_WHITE, Ncurses::COLOR_BLUE)
Ncurses.init_pair(5, Ncurses::COLOR_YELLOW, Ncurses::COLOR_BLACK)
Ncurses.init_pair(6, Ncurses::COLOR_MAGENTA, Ncurses::COLOR_BLACK)
Ncurses.init_pair(7, Ncurses::COLOR_BLACK, Ncurses::COLOR_CYAN)
Ncurses.cbreak           # provide unbuffered input
Ncurses.nonl             # turn off newline translation
Ncurses.clear

curarea =  2
test = Fileindex.new
test.scan(curarea)
=end