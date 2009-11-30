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

 Source File: tgpermissions.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: RBAC Permissions Functions


---[ Changelog ]-------------------------------------------------------------



---[ TODO Items ]------------------------------------------------------------


=end
#


class Permissions

attr_accessor  :permsin, :permsout, 
	:allowlogin,
	:readmail,
	:sendmail,
	:msgsarea,
	:readpost,
	:writepost,
	:pagesysop,
 	:chat,
	:filesarea,
	:downloads,
	:uploads,
	:extprogs,
	:admin_all,
	:admin_system,
	:admin_files,
	:admin_msgs,
	:admin_users,
	:admin_groups,
	:admin_chat,
	:admin_extprogs,
	:admin_mail,
	:dailytimelimit,
	:maxtimedeposit,
	:maxtimewithdraw,
	:maxcredits,
	:maxdownloads,
	:maxdownloadsmb,
	:maxuploads,
	:mailquota,
	:maxbulklists,
	:maxposts

def initialize
	cfg = TGconfig.new
	@cfgin = cfg.load
end


#
# Load permissions of the target user by uid
# 
def loadperms(curuid)

	permsin = Permissions.new

	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

			dbquery = dbc.execute("SELECT * FROM permissions WHERE uid=#{curuid}")
			while row = dbquery.fetch do
				permsin.allowlogin 		= row['allowlogin']
				permsin.readmail 			= row['readmail']
				permsin.sendmail 			= row['sendmail']
				permsin.msgsarea			= row['msgsarea']
				permsin.readpost 			= row['readpost']
				permsin.writepost 		= row['writepost']
				permsin.pagesysop 		= row['pagesysop']
				permsin.chat 				= row['chat']
				permsin.filesarea			= row['filesarea']
				permsin.downloads			= row['downloads']
				permsin.uploads			= row['uploads']
				permsin.extprogs			= row['extprogs']
				permsin.dailytimelimit 	= row['dailytimelimit']
				permsin.maxtimedeposit 	= row['maxtimedeposit']
				permsin.maxtimewithdraw	= row['maxtimewithdraw']
				permsin.maxcredits		= row['maxcredits']
				permsin.maxdownloads		= row['maxdownloads']
				permsin.maxdownloadsmb	= row['maxdownloadsmb']
				permsin.maxuploads		= row['maxuploads']
				permsin.mailquota			= row['mailquota']
				permsin.maxbulklists		= row['maxbulklists']
				permsin.maxposts			= row['maxposts']
				permsin.admin_all			= row['admin_all']
				permsin.admin_system		= row['admin_system']
				permsin.admin_files		= row['admin_files']
				permsin.admin_msgs		= row['admin_msgs']
				permsin.admin_users		= row['admin_users']
				permsin.admin_groups		= row['admin_groups']
				permsin.admin_chat		= row['admin_chat']
				permsin.admin_extprogs	= row['admin_extprogs']
				permsin.admin_mail		= row['admin_mail']
			end	
			dbquery.finish
	permsin
end

#
# Set and Update user's Permissions from group template
#
def changeperms(curuid, targetgid, isnew=false)

	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

			dbquery = dbc.execute("SELECT * FROM permissions WHERE gid=#{targetgid}")
			while row = dbquery.fetch do
				new_allowlogin 		= row['allowlogin']
				new_readmail 			= row['readmail']
				new_sendmail 			= row['sendmail']
				new_msgsarea			= row['msgsarea']
				new_readpost 			= row['readpost']
				new_writepost 			= row['writepost']
				new_pagesysop 			= row['pagesysop']
				new_chat 				= row['chat']
				new_filesarea			= row['filesarea']
				new_downloads			= row['downloads']
				new_uploads				= row['uploads']
				new_extprogs			= row['extprogs']
				new_dailytimelimit 	= row['dailytimelimit']
				new_maxtimedeposit 	= row['maxtimedeposit']
				new_maxtimewithdraw	= row['maxtimewithdraw']
				new_maxcredits			= row['maxcredits']
				new_maxdownloads		= row['maxdownloads']
				new_maxdownloadsmb	= row['maxdownloadsmb']
				new_maxuploads			= row['maxuploads']
				new_mailquota			= row['mailquota']
				new_maxbulklists		= row['maxbulklists']
				new_maxposts			= row['maxposts']
				new_admin_all			= row['admin_all']
				new_admin_system		= row['admin_system']
				new_admin_files		= row['admin_files']
				new_admin_msgs			= row['admin_msgs']
				new_admin_users		= row['admin_users']
				new_admin_groups		= row['admin_groups']
				new_admin_chat			= row['admin_chat']
				new_admin_extprogs	= row['admin_extprogs']
				new_admin_mail			= row['admin_mail']
			end	
			dbquery.finish

unless isnew == true

dbquery = dbc.execute("UPDATE permissions SET 
allowlogin = #{new_allowlogin},
readmail = #{new_readmail},
sendmail = #{new_sendmail},
msgsarea = #{new_msgsarea}, 
readpost = #{new_readpost},
writepost = #{new_writepost}, 
pagesysop = #{new_pagesysop}, 
chat = #{new_chat}, 
filesarea = #{new_filesarea}, 
downloads = #{new_downloads}, 
uploads = #{new_uploads}, 
extprogs =#{new_extprogs}, 
dailytimelimit = #{new_dailytimelimit},
maxtimedeposit = #{new_maxtimedeposit},
maxtimewithdraw = #{new_maxtimewithdraw},
maxcredits = #{new_maxcredits},
maxdownloads = #{new_maxdownloads},
maxdownloadsmb = #{new_maxdownloadsmb},
maxuploads = #{new_maxuploads},
mailquota = #{new_mailquota},
maxbulklists = #{new_maxbulklists},
maxposts = #{new_maxposts},
admin_all = #{new_admin_all}, 
admin_system = #{new_admin_system}, 
admin_files = #{new_admin_files}, 
admin_msgs = #{new_admin_msgs},
admin_users = #{new_admin_users}, 
admin_groups = #{new_admin_groups},
admin_chat = #{new_admin_chat}, 
admin_extprogs = #{new_admin_extprogs}, 
admin_mail = #{new_admin_mail}
WHERE uid='#{curuid}'")

else

dbquery = dbc.execute("INSERT INTO permissions(
uid,
allowlogin,
readmail,
sendmail,
msgsarea, 
readpost,
writepost, 
pagesysop, 
chat, 
filesarea, 
downloads, 
uploads, 
extprogs, 
dailytimelimit,
maxtimedeposit,
maxtimewithdraw,
maxcredits,
maxdownloads,
maxdownloadsmb,
maxuploads,
mailquota,
maxbulklists,
maxposts,
admin_all, 
admin_system, 
admin_files, 
admin_msgs, 
admin_users, 
admin_groups,
admin_chat, 
admin_extprogs, 
admin_mail
)

VALUES( 
#{curuid},
#{new_allowlogin},
#{new_readmail},
#{new_sendmail},
#{new_msgsarea}, 
#{new_readpost},
#{new_writepost}, 
#{new_pagesysop}, 
#{new_chat}, 
#{new_filesarea}, 
#{new_downloads}, 
#{new_uploads}, 
#{new_extprogs}, 
#{new_dailytimelimit},
#{new_maxtimedeposit},
#{new_maxtimewithdraw},
#{new_maxcredits},
#{new_maxdownloads},
#{new_maxdownloadsmb},
#{new_maxuploads},
#{new_mailquota},
#{new_maxbulklists},
#{new_maxposts},
#{new_admin_all}, 
#{new_admin_system}, 
#{new_admin_files}, 
#{new_admin_msgs}, 
#{new_admin_users}, 
#{new_admin_groups},
#{new_admin_chat}, 
#{new_admin_extprogs}, 
#{new_admin_mail}
)")
end
	dbquery.finish

end



	# edit permissions. exact same as Group editor, but uses the UID instead of GID
def edituserperms(curuid, login, memberof)
	# SQL ITEMS
	submenuloop = 1
	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
									 "#{@cfgin.db_user}", "#{@cfgin.db_pass}")
	while submenuloop > 0

		dbquery = dbc.execute "SELECT * FROM permissions WHERE uid = '#{curuid}'; "
		while row = dbquery.fetch do
				allowlogin 		= row['allowlogin']
				readmail 		= row['readmail']
				sendmail 		= row['sendmail']
				msgsarea			= row['msgsarea']
				readpost 		= row['readpost']
				writepost 		= row['writepost']
				pagesysop 		= row['pagesysop']
				chat 				= row['chat']
				filesarea		= row['filesarea']
				downloads		= row['downloads']
				uploads			= row['uploads']
				extprogs			= row['extprogs']
				admin_all		= row['admin_all']
				admin_system	= row['admin_system']
				admin_files		= row['admin_files']
				admin_msgs		= row['admin_msgs']
				admin_users		= row['admin_users']
				admin_groups	= row['admin_groups']
				admin_chat		= row['admin_chat']
				admin_extprogs	= row['admin_extprogs']
				admin_mail		= row['admin_mail']
				dailytimelimit = row['dailytimelimit']
				maxtimedeposit = row['maxtimedeposit']
				maxtimewithdraw= row['maxtimewithdraw']
				maxcredits		= row['maxcredits']
				maxdownloads	= row['maxdownloads']
				maxdownloadsmb	= row['maxdownloadsmb']
				maxuploads		= row['maxuploads']
				mailquota		= row['mailquota']
				maxbulklists	= row['maxbulklists']
				maxposts			= row['maxposts']
			end
		dbquery.finish


	 	newvalue = "" # clear the newvalue variable each loop
		submenu = Ncurses.newwin(23,78,2,1)
		submenu.attron(Ncurses.COLOR_PAIR(1))
		submenu.box(0,0)
	   submenu.mvhline(2,1,0,76)
	   submenu.mvhline(5,1,0,76)
	   submenu.mvhline(20,1,0,76)
		# column separator
	   submenu.mvvline(6,25,0,12)
	   submenu.mvvline(6,52,0,12)
		submenu.attroff(Ncurses.COLOR_PAIR(1))
		submenu.clear
	 	submenu.attron(Ncurses.COLOR_PAIR(5))
	 	submenu.attron(Ncurses.COLOR_PAIR(7))
		clearline = " " * 76
		submenu.mvaddstr(1, 1, "#{clearline}")
	 	submenu.mvaddstr(1, 3, "User Permission Editor")
	 	submenu.attroff(Ncurses.COLOR_PAIR(7))
	 	submenu.attron(Ncurses::A_BOLD)
		submenu.attron(Ncurses.COLOR_PAIR(5))
		submenu.attroff(Ncurses.COLOR_PAIR(5))
 		submenu.attron(Ncurses.COLOR_PAIR(1))
		submenu.mvaddstr(3,2, "       UID:")
		submenu.mvaddstr(4,2, "Login Name:")
		submenu.mvaddstr(3,24, "MemberOf:")
		submenu.mvaddstr(5,28, "[                    ]")
	 	submenu.attron(Ncurses::A_REVERSE)
		submenu.mvaddstr(5,29, " Toggle Permissions ")
	 	submenu.attroff(Ncurses::A_REVERSE)

		submenu.mvaddstr(6,2, "2. Allow login:")
		submenu.mvaddstr(7,2, "3. Page sysop :")
		submenu.mvaddstr(8,2, "4. User chat  :")
		submenu.mvaddstr(9,2, "5. Read E-mail:")
		submenu.mvaddstr(10,2,"6. Send E-mail:")
		submenu.mvaddstr(11,2,"7. Msgs Areas :")
		submenu.mvaddstr(12,2,"8. Read  Posts:")
		submenu.mvaddstr(13,2,"9. Write Posts:")
		submenu.mvaddstr(14,2,"A. File Areas :")
		submenu.mvaddstr(15,2,"B. U/L allowed:")
		submenu.mvaddstr(16,2,"C. D/L allowed:")

		submenu.mvaddstr(6,27, "D. Run Ext Prog:")
		submenu.mvaddstr(7,27, "E. Time Limit /day :")
		submenu.mvaddstr(8,27, "F. Max Time Deposit:")
		submenu.mvaddstr(9,27, "G. Max Time Withdrw:")
		submenu.mvaddstr(10,27,"H. Max # of Credits:")
		submenu.mvaddstr(11,27,"I. Max # D/L's /day:")
		submenu.mvaddstr(12,27,"J. Max D/L's in MB :")
		submenu.mvaddstr(13,27,"K. Max # U/L's /day:")
		submenu.mvaddstr(14,27,"L. Mailbox Quota MB:")
		submenu.mvaddstr(15,27,"M. Max # Mail Lists:")
		submenu.mvaddstr(16,27,"N. Max # Posts /day:")

		submenu.mvaddstr(6,54, "O. Admin All   :")
		submenu.mvaddstr(7,54, "P. Admin  Sys   :")
		submenu.mvaddstr(8,54, "Q. Admin Msgs  :")
		submenu.mvaddstr(9,54, "R. Admin Files : ")
		submenu.mvaddstr(10,54,"S. Admin Users :")
		submenu.mvaddstr(11,54,"T. Admin Groups:")
		submenu.mvaddstr(12,54,"U. Admin Chat  :")
		submenu.mvaddstr(13,54,"V. Admin Progs :")
		submenu.mvaddstr(14,54,"W. Admin Email :")
		submenu.mvaddstr(15,54,"Y. ")
		submenu.mvaddstr(16,54,"Z. ")

	   submenu.mvhline(17,1,0,76)
#		submenu.mvaddstr(18,2,"]. Next GID")
#		submenu.mvaddstr(19,2,"[. Prev GID")
#		submenu.mvaddstr(18,20, "*. List Members")
#		submenu.mvaddstr(19,20, " . ")
#		submenu.mvaddstr(18,38, "+. Add new Group")
#		submenu.mvaddstr(19,38, "-. Delete  Group")
#		submenu.mvaddstr(18,59, "_. ")
		submenu.mvaddstr(19,59, "X. Exit Perms")

		

 		submenu.attroff(Ncurses.COLOR_PAIR(1))

		# display menu prompt
	 	submenu.attron(Ncurses.COLOR_PAIR(6))
	   submenu.mvaddstr(21, 2, "Selection [0-9,A-X] :")
	   submenu.attroff(Ncurses.COLOR_PAIR(6))

    	submenu.attron(Ncurses.COLOR_PAIR(3))
	 	submenu.mvaddstr(3, 14, "#{curuid}")
	 	submenu.mvaddstr(4, 14, "#{login}")
	 	submenu.mvaddstr(3, 34, "#{memberof.upcase}")

	 	submenu.mvaddstr(6, 18, "#{allowlogin}")
	 	submenu.mvaddstr(7, 18, "#{pagesysop}")
	 	submenu.mvaddstr(8, 18, "#{chat}")
	 	submenu.mvaddstr(9, 18, "#{readmail}")
	 	submenu.mvaddstr(10, 18, "#{sendmail}")
	 	submenu.mvaddstr(11, 18, "#{msgsarea}")
	 	submenu.mvaddstr(12, 18, "#{readpost}")
	 	submenu.mvaddstr(13, 18, "#{writepost}")
	 	submenu.mvaddstr(14, 18, "#{filesarea}")
	 	submenu.mvaddstr(15, 18, "#{uploads}")
	 	submenu.mvaddstr(16, 18, "#{downloads}")

	 	submenu.mvaddstr(6, 45, "#{extprogs}")
	 	submenu.mvaddstr(7, 48, "#{dailytimelimit}")
	 	submenu.mvaddstr(8, 48, "#{maxtimedeposit}")
	 	submenu.mvaddstr(9, 48, "#{maxtimewithdraw}")
	 	submenu.mvaddstr(10,48, "#{maxcredits}")
	 	submenu.mvaddstr(11,48, "#{maxdownloads}")
	 	submenu.mvaddstr(12,48, "#{maxdownloadsmb}")
	 	submenu.mvaddstr(13,48, "#{maxuploads}")
	 	submenu.mvaddstr(14,48, "#{mailquota}")
	 	submenu.mvaddstr(15,48, "#{maxbulklists}")
	 	submenu.mvaddstr(16,48, "#{maxposts}")

	 	submenu.mvaddstr(6, 71, "#{admin_all}")
	 	submenu.mvaddstr(7, 71, "#{admin_system}")
	 	submenu.mvaddstr(8, 71, "#{admin_msgs}")
	 	submenu.mvaddstr(9, 71, "#{admin_files}")
	 	submenu.mvaddstr(10, 71, "#{admin_users}")
	 	submenu.mvaddstr(11, 71, "#{admin_groups}")
	 	submenu.mvaddstr(12, 71, "#{admin_chat}")
	 	submenu.mvaddstr(13, 71, "#{admin_extprogs}")
	 	submenu.mvaddstr(14, 71, "#{admin_mail}")
#	 	submenu.mvaddstr(15, 71, "#{}")
#	 	submenu.mvaddstr(16, 71, "#{}")

    	submenu.attroff(Ncurses.COLOR_PAIR(3))

		submenu.attron(Ncurses.COLOR_PAIR(2))
		submenu.mvaddstr(21, 24, " ")
		submenu.mvaddstr(21, 24, "")
		submenu.refresh
		submenuitem = submenu.getch()

	   case submenuitem

		when 'x'[0], 'X'[0]
			submenuloop = 0

		when '2'[0] # RBAC Allow Login
			if allowlogin == true
				allowlogin = false
			else
				allowlogin = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET allowlogin = '#{allowlogin}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when '3'[0] # RBAC Page Sysop
			if pagesysop == true
				pagesysop = false
			else
				pagesysop = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET pagesysop = '#{pagesysop}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when '4'[0] # RBAC User Chat
			if chat == true
				chat = false
			else
				chat = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET chat = '#{chat}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when '5'[0] # RBAC Read Mail
			if readmail == true
				readmail = false
			else
				readmail = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET readmail = '#{readmail}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when '6'[0] # RBAC Send Mail
			if sendmail == true
				sendmail = false
			else
				sendmail = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET sendmail = '#{sendmail}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when '7'[0], '7'[0] # RBAC Access Message Areas
			if msgsarea == true
				msgsarea = false
			else
				msgsarea = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET msgsarea = '#{msgsarea}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when '8'[0] # RBAC Read Posts
			if readpost == true
				readpost = false
			else
				readpost = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET readpost = '#{readpost}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when '9'[0] # RBAC Write Posts
			if writepost == true
				writepost = false
			else
				writepost = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET writepost = '#{writepost}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'a'[0], 'A'[0] # RBAC Access File Areas
			if filesarea == true
				filesarea = false
			else
				filesarea = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET filesarea = '#{filesarea}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'b'[0], 'B'[0] # RBAC Upload Files
			if uploads == true
				uploads = false
			else
				uploads = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET uploads = '#{uploads}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'c'[0], 'C'[0] # RBAC Download Files
			if downloads == true
				downloads = false
			else
				downloads = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET downloads = '#{downloads}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'd'[0], 'D'[0] # RBAC External Programs
			if extprogs == true
				extprogs = false
			else
				extprogs = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET extprogs = '#{extprogs}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'e'[0], 'E'[0] # Time limit per day
		 clearline = " " * 3
			 submenu.mvaddstr(7, 48, "#{clearline}")
			 submenu.move(7,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					dailytimelimit = newvalue.to_i
					if dailytimelimit >= -1 && dailytimelimit < 1000
 						dbquery = dbc.execute("UPDATE permissions SET dailytimelimit = #{dailytimelimit} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'f'[0], 'F'[0] # Max Timebank Deposit per day
		 clearline = " " * 3
			 submenu.mvaddstr(8, 48, "#{clearline}")
			 submenu.move(8,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					maxtimedeposit = newvalue.to_i
					if maxtimedeposit >= -1 && maxtimedeposit < 1000
 						dbquery = dbc.execute("UPDATE permissions SET maxtimedeposit = #{maxtimedeposit} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'g'[0], 'G'[0] # Max Timebank Deposit per day
		 clearline = " " * 3
			 submenu.mvaddstr(9, 48, "#{clearline}")
			 submenu.move(9,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					maxtimewithdraw = newvalue.to_i
					if maxtimewithdraw >= -1 && maxtimewithdraw < 1000
 						dbquery = dbc.execute("UPDATE permissions SET maxtimewithdraw = #{maxtimewithdraw} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'h'[0], 'H'[0] # Max Credits Total This user may have
		 clearline = " " * 3
			 submenu.mvaddstr(10, 48, "#{clearline}")
			 submenu.move(10,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					maxcredits = newvalue.to_i
					if maxcredits >= -1 && maxcredits < 1000
 						dbquery = dbc.execute("UPDATE permissions SET maxcredits = #{maxcredits} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'i'[0], 'I'[0] # Max number of downloads per day
		 clearline = " " * 3
			 submenu.mvaddstr(11, 48, "#{clearline}")
			 submenu.move(11,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					maxdownloads = newvalue.to_i
					if maxdownloads >= -1 && maxdownloads < 1000
 						dbquery = dbc.execute("UPDATE permissions SET maxdownloads = #{maxdownloads} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'j'[0], 'J'[0] # Max Kilobytes downloaded per day
		 clearline = " " * 3
			 submenu.mvaddstr(12, 48, "#{clearline}")
			 submenu.move(12,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					maxdownloadskb = newvalue.to_i
					if maxdownloadskb >= -1 && maxdownloadskb < 1000
 						dbquery = dbc.execute("UPDATE permissions SET maxdownloadsmb = #{maxdownloadsmb} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'k'[0], 'K'[0] # Max Uploads per day
		 clearline = " " * 3
			 submenu.mvaddstr(13, 48, "#{clearline}")
			 submenu.move(13,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					maxuploads = newvalue.to_i
					if maxuploads >= -1 && maxuploads < 1000
 						dbquery = dbc.execute("UPDATE permissions SET maxuploads = #{maxuploads} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'l'[0], 'L'[0] # Mailbox Quota in megabytes
		 clearline = " " * 4
			 submenu.mvaddstr(14, 48, "#{clearline}")
			 submenu.move(14,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					mailquota = newvalue.to_i
					if mailquota >= -1 && mailquota < 10000
 						dbquery = dbc.execute("UPDATE permissions SET mailquota = #{mailquota} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'm'[0], 'M'[0] # Max # Mail Lists
		 clearline = " " * 2
			 submenu.mvaddstr(15, 48, "#{clearline}")
			 submenu.move(15,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					maxbulklists = newvalue.to_i
					if maxbulklists >= -1 && maxbulklists < 20
 						dbquery = dbc.execute("UPDATE permissions SET maxbulklists = #{maxbulklists} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'n'[0], 'N'[0] # Max Posts Per Day
		 clearline = " " * 3
			 submenu.mvaddstr(16, 48, "#{clearline}")
			 submenu.move(16,48)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					maxposts = newvalue.to_i
					if maxposts >= -1 && maxposts < 1000
 						dbquery = dbc.execute("UPDATE permissions SET maxposts = #{maxposts} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'o'[0], 'O'[0] # RBAC Admin All
			if admin_all == true
				admin_all = false
			else
				admin_all = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_all = '#{admin_all}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'p'[0], 'P'[0] # RBAC Admin System
			if admin_system == true
				admin_system = false
			else
				admin_system = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_system = '#{admin_system}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'q'[0], 'Q'[0] # RBAC Admin Message Areas
			if admin_msgs == true
				admin_msgs = false
			else
				admin_msgs = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_msgs = '#{admin_msgs}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'r'[0], 'R'[0] # RBAC Admin File Areas
			if admin_files == true
				admin_files = false
			else
				admin_files = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_files = '#{admin_files}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 's'[0], 'S'[0] # RBAC Admin Users
			if admin_users == true
				admin_users = false
			else
				admin_users = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_users = '#{admin_users}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 't'[0], 'T'[0] # RBAC Admin Groups
			if admin_groups == true
				admin_groups = false
			else
				admin_groups = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_groups = '#{admin_groups}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'u'[0], 'U'[0] # RBAC Admin Chat
			if admin_chat == true
				admin_chat = false
			else
				admin_chat = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_chat = '#{admin_chat}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'v'[0], 'V'[0] # RBAC Admin External Programs
			if admin_extprogs == true
				admin_extprogs = false
			else
				admin_extprogs = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_extprogs = '#{admin_extprogs}' WHERE uid = '#{curuid}'")
			dbquery.finish

		when 'w'[0], 'W'[0] # RBAC Admin Mail System
			if admin_mail == true
				admin_mail = false
			else
				admin_mail = true
			end 
			dbquery = dbc.execute("UPDATE permissions SET admin_mail = '#{admin_mail}' WHERE uid = '#{curuid}'")
			dbquery.finish
		else
		end # end case	


	end # end while
	dbc.disconnect
	submenu.delwin
end # end def

end
