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

 Source File: tgusers.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: User Handling Routines

### SAMPLE USAGE

cleartxt = "secret"
prog = Password.new
password = prog.crypt(cleartxt)
puts "#{password}   |   #{password.length}"
print "Enter Password for comparison: "
inpw = gets.chomp
auth = prog.auth(inpw, password)
puts auth

---[ Changelog ]-------------------------------------------------------------



---[ TODO Items ]------------------------------------------------------------

 * Permissions needs to become an Object Class to solve some hurdles

=end
#
# -



class Password

attr_accessor :password, :key, :crypt_type, :docrypt, :tgkey, :newpw, :cryptedpw

 def initialize
	cfg = TGconfig.new
	@cfgin = cfg.load
 end

 # Simple function to return a cleartxt passed value to sha2 hex digest
 def crypt(cleartxt)
	password = BCrypt::Password.create(cleartxt)
	password

### OLD METHOD USING JUST SHA2 - Easy to break, not salted 
#		docrypt = Digest::SHA2.new(bitlen = 512)
#		password = docrypt.hexdigest(cleartxt)
#		password
###=========================================================

 end # end crypt



 # This is a function that returns success or fail for a login attempt
 # it is passed the cleartxt password, and then a retrieved crypted string
 # from either a database or file. This function compares the 2 values.
def auth(cleartxt, stored)
	dbpwd = BCrypt::Password.new("#{stored}")
	if dbpwd == "#{cleartxt}"
		return true
	else
		return false
	end
end # end auth

def pwprompt
	HighLine.color_scheme = Tgcolors02
	prompt = "<%= color('Password:', :prompt)%> "
   ask(prompt) {|q| q.echo = "%" }
end


# Administration Interface Reset
def adminreset(curuid)

	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")
	popuploop = 1
	while popuploop > 0
		popup = Ncurses.newwin(5,34,8,18)
 		popup.attron(Ncurses.COLOR_PAIR(8))
		popup.box(0,0)
		popup.clear
		popup.mvaddstr(0,3, "[                  ]")
		popup.attron(Ncurses.COLOR_PAIR(5))
		popup.mvaddstr(0,5, "Enter New Password")
	  	popup.attron(Ncurses::A_BOLD)
		popup.attron(Ncurses.COLOR_PAIR(2))
		clearline = " " * 30
		popup.mvaddstr(2,2, "#{clearline}")
		popup.move(2,2)
		popup.refresh
		newpw = ""
		popup.getstr newpw
			if newpw.nil?
				popuploop = 0
			else
			pwexpiry 	= Time.now + @cfgin.user_pwexpires.days
			pwexpires 	= "#{pwexpiry.year}-#{pwexpiry.month}-#{pwexpiry.day}"

			cryptedpw = self.crypt(newpw)
			dbquery = dbc.execute "UPDATE users SET password='#{cryptedpw}', pwexpires='#{pwexpires}' WHERE uid='#{curuid}';"
					popup.attron(Ncurses.COLOR_PAIR(6))
					popup.mvaddstr(0,5, " Password Changed ")
					popup.attron(Ncurses.COLOR_PAIR(4))
					popup.mvaddstr(2,2, "#{clearline}")
					popup.mvaddstr(2,2, "Successfully updated DB")
					popup.attroff(Ncurses.COLOR_PAIR(3))
					popup.mvaddstr(4,14, "[ OK ]")
	 	      	popup.attron(Ncurses::A_REVERSE)
					popup.move(4,18)
	 	      	popup.attroff(Ncurses::A_REVERSE)
					popup.refresh
					popup.getch
				popuploop = 0
			end # END IF
		end # END WHILE
	popup.delwin
	return 0	# Return results and let calling function handle output

end # end def


end # end class




class User

attr_accessor :who, :cfgin, :cfg, :dbquery, :newvalue, :clearline,
:uid, :gid, :login, :password, :firstname, :lastname, :address,
:city, :state, :country, :phone, :gender, :bday, :email, :memberof,
:sysopnote, :pwhint, :pwexpires, :curuid, :totaluids, :uidindex,
:dailytimelimit, :maxtimedeposit, :maxtimewithdraw, :maxcredits,
:maxdownloads, :maxdownloadskb, :maxuploads, :mailquota, :islocked,
:maxbulklists, :maxposts, :totalfilesup, :totalfilesdown, 
:loginfailed



	def initialize
		cfg = TGconfig.new
		@cfgin = cfg.load
	 end


#
# Login Prompt
#
def loginprompt
	HighLine.color_scheme = Tgcolors02
	prompt = "<%= color('Login:', :prompt)%> "
   ask(prompt)
end



#
# Login routine. Returns user data to calling function
#
def login
	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")
	count = 0 
	maxfail = @cfgin.login_maxpercall

	while count < maxfail 
		login = self.loginprompt
		if login.upcase == "NEW"
			if @cfgin.bbs_allownew == true
				userdata = self.signup
				if userdata == nil
					return nil
				else
					return userdata
				end
			else
				ansiputs("This BBS is not currently accepting new users.\n", red)
				return nil
			end
		end
		checklogin = dbc.select_one("SELECT login FROM users WHERE login='#{login}'")
		if checklogin.nil?
			puts "Invalid User, use 'NEW' to create a new account"
		else
			# Check if user is locked
		   dbquery = dbc.execute("SELECT islocked FROM users WHERE login='#{login}'")
				while row = dbquery.fetch
					islocked = row['islocked']
				end
			dbquery.finish

			if islocked == true
				ansiputs("This account has been LOCKED by the system.\n", red)
				return nil
			end
			userpw = Password.new
			cleartxt = userpw.pwprompt
			dbquery = dbc.execute("SELECT password, loginfailed FROM users WHERE login='#{login}'")
			while row = dbquery.fetch do 
				dbpwd = row['password']
				loginfailed = row['loginfailed']
			end
			dbquery.finish
			pwresult = userpw.auth(cleartxt, dbpwd)
			if pwresult == false
				puts "Login Failed"
				loginfailed = loginfailed + 1
				# check if we should ask about secret question
				if count >= @cfgin.login_asksecret && loginfailed < @cfgin.login_maxfailed
					pwhint = dbc.select_one("SELECT pwhint FROM users WHERE login='#{login}'")
					ansiputs("Password Hint: ",yellow) 
					ansiputs("#{pwhint}\n", cyan)
				end
				dbquery = dbc.execute("UPDATE users SET loginfailed = #{loginfailed} WHERE login='#{login}'")
				if loginfailed >= @cfgin.login_maxfailed
					dbquery = dbc.execute("UPDATE users SET islocked = true WHERE login='#{login}'")
				end 
				dbquery.finish
			else
				# Login Success, return login name
				dbquery = dbc.execute("SELECT * FROM users WHERE login='#{login}'")
					userdata = dbquery.fetch_hash
					logintotal = userdata['logintotal'].to_i
					logintotal = logintotal + 1
					curtime = Time.now
					dbquery = dbc.execute("UPDATE users SET logintotal = #{logintotal}, lastlogin = '#{curtime}' WHERE login='#{login}'")
				dbquery.finish

				return userdata
			end
		end # end if
		count = count + 1
	end # end while
	puts "Max login attempts reached - Goodbye..."
	return nil # Default to failed login if we get here
end # end def



#
# New User Signup - Passed only by login.
#
def signup

dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

HighLine.color_scheme = Tgcolors02

# TODO: Display new user acceptance agreement, paged out
printansifile("#{@cfgin.path_ansi}/eula.ans")
say("<%= color('Do you agree to this system usage agreement?', :warning) %> ")

prompt = "[y/n]: "
eua = agree(prompt, true)
#eua = agree("[y/N]", true)
if eua == false
	return nil
end


printansifile("#{@cfgin.path_ansi}/signup.ans")

#TODO: Allow certain items to be made optional by BBS Settings

	firstname	= self.askfirstname
	lastname 	= self.asklastname 
	address		= self.askstreet
	city 			= self.askcity
	state 		= self.askstate
	postal 		= self.askpostal
	country 		= self.askcountry
	email 		= self.askemail
	gender	 	= self.askgender
	bdaymonth	= self.askbdaymonth
	bdayday		= self.askbdayday
	bdayyear		= self.askbdayyear
	login 		= self.asklogin
	password 	= self.askpassword
	pwhint 		= self.askpwhint

	pwexpiry 	= Time.now + cfgin.user_pwexpires.days

	# ISO-8601 Format: PGSQL recommended
	bday 			= "#{bdayyear}-#{bdaymonth}-#{bdayday}"
	pwexpires 	= "#{pwexpiry.year}-#{pwexpiry.month}-#{pwexpiry.day}"


confirmloop = 1
while confirmloop > 0
	ansiclear
	puts "\n"
	ansiputs("\t----==[ ", magenta)
	ansiputs("User Account Creation Summary", white)
	ansiputs(" ]==----\n\n", magenta)
	ansiputs("Your BBS account will be created using the information shown.\n\n", white)
	ansiputs("1. Login Name : ", blue)
	ansiputs("#{login} \n", cyan)
	ansiputs("2. First Name : ", blue)
	ansiputs("#{firstname} \n", cyan)
	ansiputs("3. Last Name  : ", blue)
	ansiputs("#{lastname} \n", cyan)
	ansiputs("4. Street Addr: ", blue)
	ansiputs("#{address} \n", cyan)
	ansiputs("5. City       : ", blue)
	ansiputs("#{city} \n", cyan)
	ansiputs("6. State      : ", blue)
	ansiputs("#{state} \n", cyan)
	ansiputs("7. Country    : ", blue)
	ansiputs("#{country} \n", cyan)
	ansiputs("8. Postal Code: ", blue)
	ansiputs("#{postal} \n", cyan)
	ansiputs("9. Email Addr : ", blue)
	ansiputs("#{email} \n", cyan)
	ansiputs("A. Gender     : ", blue)
	ansiputs("#{gender}\n", cyan, false)
	ansiputs("B. Birthdate  : ", blue)
	ansiputs("#{bday}\n", cyan, false)
	ansiputs("C. Passwd Hint: ", blue)
	ansiputs("#{pwhint}\n", cyan, false)
	ansiputs("D. Password   : ", blue)
	ansiputs("<HIDDEN> (expires: #{pwexpires})\n", cyan, false)

	ansiputs("X. Save & Login\n", blue)
	ansiputs("G. Goodbye (abort)\n", blue)
	puts ""

	change = ask("<%= color('Select: ', :warning)%> ") do |q|
		q.limit = 1
		q.echo = "#{change}"
	end
	case change.upcase
		when "1"
			login 		= self.asklogin
		when "2"
			firstname	= self.askfirstname
		when "3"
			lastname 	= self.asklastname 
		when "4"
			address		= self.askstreet
		when "5"
			city 			= self.askcity
		when "6"
			state 		= self.askstate
		when "7"
			country 		= self.askcountry
		when "8"
			postal 		= self.askpostal
		when "9"
			email 		= self.askemail
		when "A"
			gender		= self.askgender
		when "B"
			bdaymonth	= self.askbdaymonth
			bdayday		= self.askbdayday
			bdayyear		= self.askbdayyear
		when "C"
			password 	= self.askpwhint
		when "D"
			password 	= self.askpassword
		when "X"
			puts "Saving account..."
			confirmloop = 0
		when "G"
			puts "Aborting signup..."
			return nil
	end

newpw = Password.new
cryptedpw = newpw.crypt(password)

end # end while confirmloop

signupdate = Time.now

# Set Default Values 
timebank 	= 0
credits 		= 0
logintotal 	= 0
totalposts 	= 0
totalfilesup= 0
totalfilesdown= 0


#
# Here we determine the UID to assign to the user. There are 2 options:
# 1) We can use this method (Same as cfgeditor) to find and reduce gaps
#  or
# 2) We can use the database's autoincrement.
#
#

	i = 0	# Array iterator
	uidindex = dbc.select_all "SELECT uid FROM users ORDER BY uid;"
		totaluids = uidindex.length
		idx = 0
		sdx = 1 
		scanuids = []
		availuids = []
			uidindex.each do |uidvalue|
				scanuids << "#{uidvalue}"
				unless scanuids[idx].to_i == sdx
					availuids << sdx
				end
				sdx = sdx + 1
				idx = idx +1
			end
			# If the sequential UID check turns out nil, we add one to the end
			unless availuids.empty?
				newuid = availuids[0]
			else
				newuid = totaluids + 1
			end

#TODO: INSERT NEW USER INTO DATABASE
newuser = dbc.execute("INSERT INTO users(
	uid,
	gid,
	login,
	firstname,
	lastname,
	address,
	city,
	state,
	country,
	postal,
	email,
	password,
	pwhint,
	pwexpires,
	gender,
	bday,
	signupdate,
	timebank,
	credits,
	totalfilesup,
	totalfilesdown,
	totalposts,
	logintotal
)

VALUES(
	#{newuid},
	#{@cfgin.default_gid},
	'#{login}',
	'#{firstname}',
	'#{lastname}',
	'#{address}',
	'#{city}',
	'#{state}',
	'#{country}',
	'#{postal}',
	'#{email}',
	'#{cryptedpw}',
	'#{pwhint}',
	'#{pwexpires}',
	'#{gender}',
	'#{bday}',
	'#{signupdate}',
	#{timebank},
	#{credits},
	#{totalfilesup},
	#{totalfilesdown},
	#{totalposts},
	#{logintotal}
);


")
newuser.finish

	userperms = Permissions.new
	userperms.changeperms(newuid, @cfgin.default_gid, true)

	ansiputs("Preferences selection will go here...", yellow)

	# Returns new user data to login
	getnewuid = dbc.select_one("SELECT * FROM users WHERE login='#{login}'")
end



#
# Clear a user's failed login attempts
#
def clearfails(curuid)

	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
									 "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

	dbquery = dbc.execute("UPDATE users SET loginfailed = 0 WHERE uid = '#{curuid}'")
	dbquery.finish
end


#
# User SELF-PASSWORD resets
#
def resetpw(curuid)

	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")
	password = self.askpassword
	newpw = Password.new
	cryptedpw = newpw.crypt(password)

	pwexpiry 	= Time.now + cfgin.user_pwexpires.days
	pwexpires 	= "#{pwexpiry.year}-#{pwexpiry.month}-#{pwexpiry.day}"

	dbquery = dbc.execute("UPDATE users SET password = '#{cryptedpw}',  pwexpires = '#{pwexpires}' WHERE uid= #{curuid};")
	dbquery.finish
	ansiputs("Password change successful!", yellow)

end



#
# Find User routine
#
def find(byfield)

	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")
	popuploop = 1
	while popuploop > 0
		popupmenu = Ncurses.newwin(5,34,8,18)
 		popupmenu.attron(Ncurses.COLOR_PAIR(3))
		popupmenu.box(0,0)
		popupmenu.clear
		popupmenu.mvaddstr(0,3, "[                  ]")
		popupmenu.attron(Ncurses.COLOR_PAIR(5))
		case byfield
			when "login"
				popupmenu.mvaddstr(0,5, "Enter Login Name")
			when "firstname"
				popupmenu.mvaddstr(0,5, "Enter First Name")
			when "lastname"
				popupmenu.mvaddstr(0,5, "Enter Last  Name")
			when "city"
				popupmenu.mvaddstr(0,5, "Enter City  Name")
			when "state"
				popupmenu.mvaddstr(0,5, "Enter State Abrv")
			when "email"
				popupmenu.mvaddstr(0,5, "Enter Email Addr")
		   else
				popuploop = 0
		end
	  	popupmenu.attron(Ncurses::A_BOLD)
		popupmenu.attron(Ncurses.COLOR_PAIR(2))
		clearline = " " * 30
		popupmenu.mvaddstr(2,2, "#{clearline}")
		popupmenu.move(2,2)
#	    	popupmenu.attroff(Ncurses::A_BOLD)
		popupmenu.refresh
		usersearch = ""
		popupmenu.getstr usersearch
			if usersearch.nil?
				popuploop = 0
			else
			searchresults = dbc.select_one "SELECT uid FROM users where #{byfield} = '#{usersearch.downcase}';"
				unless searchresults.nil?
						
				else
					popupmenu.attron(Ncurses.COLOR_PAIR(6))
					popupmenu.mvaddstr(0,5, "NO RESULTS FOUND")
					popupmenu.attron(Ncurses.COLOR_PAIR(5))
					popupmenu.mvaddstr(2,2, "#{clearline}")
					popupmenu.mvaddstr(2,2, "No such #{byfield} in DB")
					popupmenu.attroff(Ncurses.COLOR_PAIR(3))
					popupmenu.mvaddstr(4,14, "[ OK ]")
	 	      	popupmenu.attron(Ncurses::A_REVERSE)
					popupmenu.move(4,18)
	 	      	popupmenu.attroff(Ncurses::A_REVERSE)
					popupmenu.refresh
					popupmenu.getch
				end
			popuploop = 0
			end
		end # END WHILE
	popupmenu.delwin
	searchresults	# Return results and let calling function handle output

end # end find


#
# List user(s) on console
#
def list(who)
			# Connect to database
			dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
									 "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

		if who.downcase == "all"  # pull all users from database?
			puts "Listing all users..."
		   dbquery = dbc.execute("SELECT login, city, state, firstname, lastname FROM users ORDER BY uid;")
		else	# Pull a specific user
			puts "Pulling record for #{who}..."
		   dbquery = dbc.execute("SELECT login, city, state, firstname, lastname FROM users WHERE login='#{who}';")
		end
		   while row = dbquery.fetch do
     			ansiputs("row[0]\t", cyan)
				ansiputs("(row[3] row[4])", green)
				ansiputs(",\t\t", white, false)
			 	ansiputs("row[1], row[2]", blue)
   		end
		   dbquery.finish

			dbc.disconnect
end # end show

# Admin users
def cfgeditor

	# TODO: Determine default GID for new users somewhere else
	dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

	curuid = 1
	i = 0	# Array iterator
	permprog = Permissions.new
	submenuloop = 1
	while submenuloop > 0

		uidindex = dbc.select_all "SELECT uid FROM users ORDER BY uid;"
		# BUG: There is a bug here that does not correctly address the UIDs.
		# This can be seen when deleting a user, and the view remains on the same UID as removed.
		# This change occurred after converting the DB Table to use Auto-increments
		# Probably need to make adjustements to the array handling of uidindex, etc...
		totaluids = uidindex.length
		lastuid = totaluids - 1
		curuid = uidindex[i]
		viewindex = i + 1

		# Get current user data
		dbquery = dbc.execute "SELECT * FROM users WHERE uid = '#{curuid}';"
		 while row = dbquery.fetch do
     			gid 			= row['gid']
				login 		= row['login']
				firstname 	= row['firstname']
				lastname 	= row['lastname']
				address 		= row['address']
				city 			= row['city']
				state 		= row['state']
				postal 		= row['postal']
				country 		= row['country']
				email 		= row['email']
				bday 			= row['bday']
				gender		= row['gender']
				phone 		= row['phone']
				sysopnote	= row['sysopnote']
				signupdate	= row['signupdate']
				lastlogin	= row['lastlogin']
				logintotal	= row['logintotal']
				totalfilesup= row['totalfilesup']
				totalfilesdown= row['totalfilesdown']
				totalposts	= row['totalposts']
				timebank		= row['timebank']
				credits		= row['credits']
				pwhint		= row['pwhint']
				pwexpires	= row['pwexpires']
				loginfailed	= row['loginfailed']
				islocked		= row['islocked']
   		end
		dbquery.finish

		# Get memberof group name
		dbquery = dbc.execute "SELECT name FROM groups WHERE gid = '#{gid}';"
		while row = dbquery.fetch do
				memberof = row[0]
		end
		dbquery.finish


# TODO: Migrate this date conversation to either tgoutput function or tgrubyext
		# Convert Dates to viewable format by showing only first 10 chars
		newsignupdate = signupdate.to_s
		newsignupdate = newsignupdate.scan(/\w/)
		signupdate = "#{newsignupdate[0..3]}-#{newsignupdate[4..5]}-#{newsignupdate[6..7]}"

		newbday = bday.to_s
		newbday = newbday.scan(/\w/)
		bday = "#{newbday[0..3]}-#{newbday[4..5]}-#{newbday[6..7]}"
		
		newpwexpires = pwexpires.to_s
		newpwexpires = newpwexpires.scan(/\w/)
		pwexpires = "#{newpwexpires[0..3]}-#{newpwexpires[4..5]}-#{newpwexpires[6..7]}"

		newlastlogin = lastlogin.to_s
		newlastlogin = newlastlogin.scan(/\w/)
		lastlogin = "#{newlastlogin[0..3]}-#{newlastlogin[4..5]}-#{newlastlogin[6..7]}@#{newlastlogin[9..10]}:#{newlastlogin[11..12]}"


	 	newvalue = "" # clear the newvalue variable each loop
		submenu = Ncurses.newwin(23,78,2,1)
		submenu.attron(Ncurses.COLOR_PAIR(8))
#	 	submenu.attron(Ncurses::A_BOLD)
		submenu.box(0,0)
	   submenu.mvhline(2,1,0,76)
  	   submenu.mvaddstr(22,4, "[           ]")
	   submenu.mvhline(18,1,0,76)
#	   submenu.mvhline(20,1,0,76)
		submenu.attroff(Ncurses.COLOR_PAIR(1))
		submenu.clear
	 	submenu.attron(Ncurses.COLOR_PAIR(7))
	 	submenu.attroff(Ncurses::A_BOLD)
		clearline = " " * 76
		submenu.mvaddstr(1, 1, "#{clearline}")
	 	submenu.mvaddstr(1, 3, "User Account Editor \t\t\t\t\tViewing [#{viewindex} / #{totaluids}]")
	 	submenu.attroff(Ncurses.COLOR_PAIR(7))

 		submenu.attron(Ncurses.COLOR_PAIR(1))

		submenu.mvaddstr(3,2, "1. Login Name:")
		submenu.mvaddstr(3,54,"UID#:")

		submenu.mvaddstr(4,2, "2. First Name :")


		submenu.mvaddstr(5,2, "3. Last Name  :")
		submenu.mvaddstr(5,44,"Signup date   :")

		submenu.mvaddstr(6,2, "4. SM Address :")
		submenu.mvaddstr(6,44,"Last login    :")

		submenu.mvaddstr(7,2, "5. City       :")
		submenu.mvaddstr(7,44,"Total logins  :")

		submenu.mvaddstr(8,2, "6. State/Prov :")
		submenu.mvaddstr(8,44,"Total posts   :")

		submenu.mvaddstr(9,2, "7. Postal code:")
		submenu.mvaddstr(9,44,"Total file U/D:")

		submenu.mvaddstr(10,2, "8. Country    :")
		submenu.mvaddstr(10,44,"F. Login Fails:")

		submenu.mvaddstr(11,2, "9. PhoneNumber:")
		submenu.mvaddstr(11,44,"L. Acct Locked:")

		submenu.mvaddstr(12,2, "0. Gender     :")
		submenu.mvaddstr(12,44,"I. PWD Expires:")

		submenu.mvaddstr(13,2, "Y. Birthday   :")
		submenu.mvaddstr(13,44,"$. Credits    :")

		submenu.mvaddstr(14,2, "E. E-Mail     :")
		submenu.mvaddstr(14,44,"T. Timebank   :")

		submenu.mvaddstr(15,2,"G. MemberOf   :")

		submenu.mvaddstr(16,2,"H. Passwd Hint:")

		submenu.mvaddstr(17,2,"N. SysOp Note :")

#		submenu.mvaddstr(14,2,"A.  :")
#		submenu.mvaddstr(15,2,"B.  :")
#		submenu.mvaddstr(16,2,"C.  :")
#		submenu.mvaddstr(17,2,"D.  :")


		submenu.mvaddstr(19,2,"]. Next UID ")
		submenu.mvaddstr(20,2,"[. Prev UID")
		submenu.mvaddstr(19,20, "+. Create user")
		submenu.mvaddstr(20,20, "-. Delete user")

		submenu.mvaddstr(19,38, "P. Permissions")
		submenu.mvaddstr(20,38, "S. Search Users")
		submenu.mvaddstr(19,59, "R. Reset Password")
		submenu.mvaddstr(20,59, "X. Exit Editor")
	
 		submenu.attroff(Ncurses.COLOR_PAIR(1))

		# display menu prompt
	 	submenu.attron(Ncurses.COLOR_PAIR(6))
	   submenu.mvaddstr(22, 6, "Select: ")
	   submenu.attroff(Ncurses.COLOR_PAIR(6))

    	submenu.attron(Ncurses.COLOR_PAIR(3))
	 	submenu.attron(Ncurses::A_BOLD)
		submenu.mvaddstr(3, 18, "#{login.upcase}")			unless login.nil?
		submenu.mvaddstr(3, 60, "#{curuid}") 					unless curuid.nil?

	 	submenu.mvaddstr(4, 18, "#{firstname.capitalize}") unless firstname.nil?

	 	submenu.mvaddstr(5, 18, "#{lastname.capitalize}") 	unless lastname.nil?
	 	submenu.mvaddstr(5, 60, "#{signupdate}") 				unless signupdate.nil?

	 	submenu.mvaddstr(6, 18, "#{address}") 					unless address.nil?
	 	submenu.mvaddstr(6, 60, "#{lastlogin}") 				unless lastlogin.nil?

	 	submenu.mvaddstr(7, 18, "#{city.capitalize}") 		unless city.nil?
	 	submenu.mvaddstr(7, 60, "#{logintotal}") 				unless logintotal.nil?

	 	submenu.mvaddstr(8, 18, "#{state.upcase}") 			unless state.nil?
	 	submenu.mvaddstr(8, 60, "#{totalposts}") 			unless totalposts.nil?

	 	submenu.mvaddstr(9, 18, "#{postal}") 					unless postal.nil?
	 	submenu.mvaddstr(9, 60, "#{totalfilesup} / #{totalfilesdown}") unless totalfilesup.nil? ||totalfilesdown.nil?

	 	submenu.mvaddstr(10, 18, "#{country.upcase}") 		unless country.nil?
	 	submenu.mvaddstr(10, 60, "#{loginfailed}") 			unless loginfailed.nil? 

	 	submenu.mvaddstr(11, 18, "#{phone.downcase}") 		unless phone.nil?
	 	submenu.mvaddstr(11, 60, "#{islocked}") 		unless islocked.nil?

	 	submenu.mvaddstr(12, 18, "#{gender}") 		unless gender.nil?
	 	submenu.mvaddstr(12, 60, "#{pwexpires}") 		unless pwexpires.nil?

	 	submenu.mvaddstr(13, 18, "#{bday}") 		unless bday.nil?
	 	submenu.mvaddstr(13, 60, "#{credits}") 				unless credits.nil?

	 	submenu.mvaddstr(14, 18, "#{email.downcase}") 		unless email.nil?
	 	submenu.mvaddstr(14, 60, "#{timebank}") 				unless timebank.nil?

	 	submenu.mvaddstr(15, 18, "#{memberof.upcase}") 		unless memberof.nil?

	 	submenu.mvaddstr(16, 18, "#{pwhint}") 		unless pwhint.nil?

	 	submenu.mvaddstr(17, 18, "#{sysopnote}") 		unless sysopnote.nil?

    	submenu.attroff(Ncurses.COLOR_PAIR(3))

		submenu.attron(Ncurses.COLOR_PAIR(2))
		submenu.mvaddstr(22, 14, " ")
		submenu.mvaddstr(22, 14, "")
		submenu.refresh
		submenuitem = submenu.getch()
   case submenuitem

		when 'x'[0], 'X'[0]
			submenuloop = 0

		when 's'[0], 'S'[0]
			# Need popupmenu to determine search criteria
			results = self.find('login')
			curuid = results[0] unless results.nil?
			
		when ']'[0] # Next UID
		 unless i >= lastuid
			i = i + 1 
		 else
			i = 0
		 end
		 curuid = uidindex[i]

		when '['[0] # Prev UID
		 unless i <= 0
			i = i - 1 
		 else
			i = lastuid
		 end
		 curuid = uidindex[i]

		when '-'[0] # Delete User
			unless "#{curuid}" == "1" # cannot delete the first area - its required
			popuploop = 1
				while popuploop > 0
					popupmenu = Ncurses.newwin(5,54,10,12)
					popupmenu.box(0,0)
					popupmenu.clear
					popupmenu.mvaddstr(0,3, "[ Confirm User Delete ]")
 					popupmenu.attron(Ncurses.COLOR_PAIR(3))
		 	      popupmenu.attron(Ncurses::A_BOLD)
					popupmenu.mvaddstr(2,2, "Are you sure? Delete this user from database now?")
					popupmenu.attron(Ncurses.COLOR_PAIR(6))
					popupmenu.mvaddstr(4, 43, "[ y/N:  ]")
					popupmenu.attron(Ncurses.COLOR_PAIR(2))
	 				popupmenu.mvaddstr(4, 50, " ")
	 				popupmenu.mvaddstr(4, 50, "")
		 	      popupmenu.attroff(Ncurses::A_BOLD)
					popupmenu.refresh
						case(popupmenu.getch())
						 	when 'y'[0], 'Y'[0]
								dbquery = dbc.execute "DELETE FROM users WHERE uid = '#{curuid}';"
								dbquery.finish
								dbquery = dbc.execute "DELETE FROM permissions WHERE uid = '#{curuid}';"
								unless i <= 0  # When completed go to the previous user
									i = i - 1 
								else
									i = lastuid
								end
								popuploop = 0
							# TODO: Ask if we want to send a final email to user
							when 'n'[0], 'N'[0]
								popuploop = 0
						end
				end # END WHILE
				popupmenu.delwin
			# END UNLESS
			end

		when '+'[0] # Add User
			idx = 0
			sdx = 1 
			scanuids = []
			availuids = []
			uidindex.each do |uidvalue|
				scanuids << "#{uidvalue}"
				unless scanuids[idx].to_i == sdx
					availuids << sdx
				end
				sdx = sdx + 1
				idx = idx +1
			end
			# If the sequential UID check turns out nil, we add one to the end
			unless availuids.empty?
				newuid = availuids[0]
			else
				newuid = totaluids + 1
			end
			signupdate = Time.now
			loginname = "NEWUSER-#{newuid}"
			# TODO: This new user creation could be better...
			dbquery = dbc.execute("INSERT INTO users(uid, gid, login, signupdate) VALUES(#{newuid}, #{@cfgin.default_gid}, '#{loginname}','#{signupdate}')")
			dbquery.finish
			permprog.changeperms(newuid, @cfgin.default_gid, true)
			i = newuid - 1

		when '1'[0] # Login  Name
			 clearline = " " * 16
			 submenu.mvaddstr(3, 18, "#{clearline}")
			 submenu.move(3,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					login = newvalue
					dbquery = dbc.execute("UPDATE users SET login = '#{login}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when '2'[0] # First Name
			 clearline = " " * 20
			 submenu.mvaddstr(4, 18, "#{clearline}")
			 submenu.move(4,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					firstname = newvalue
					dbquery = dbc.execute("UPDATE users SET firstname = '#{firstname}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when '3'[0] # Last Name
			 clearline = " " * 20
			 submenu.mvaddstr(5, 18, "#{clearline}")
			 submenu.move(5,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					lastname = newvalue
					dbquery = dbc.execute("UPDATE users SET lastname = '#{lastname}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end


		when '4'[0] # Snail Mail Address
			 clearline = " " * 30
			 submenu.mvaddstr(6, 18, "#{clearline}")
			 submenu.move(6,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					address = newvalue
					dbquery = dbc.execute("UPDATE users SET address = '#{address}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when '5'[0] # City
			 clearline = " " * 20
			 submenu.mvaddstr(7, 18, "#{clearline}")
			 submenu.move(7,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					city = newvalue
					dbquery = dbc.execute("UPDATE users SET city = '#{city}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when '6'[0] # State
			 clearline = " " * 4
			 submenu.mvaddstr(8, 18, "#{clearline}")
			 submenu.move(8,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					state = newvalue
					dbquery = dbc.execute("UPDATE users SET state = '#{state}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when '7'[0] # Postal Code
			 clearline = " " * 12
			 submenu.mvaddstr(9, 18, "#{clearline}")
			 submenu.move(9,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					postal = newvalue
					dbquery = dbc.execute("UPDATE users SET postal = '#{postal}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when '8'[0] # Country
			 clearline = " " * 4
			 submenu.mvaddstr(10, 18, "#{clearline}")
			 submenu.move(10,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					country = newvalue
					dbquery = dbc.execute("UPDATE users SET country = '#{country}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when '9'[0] # Telephone
			 clearline = " " * 15
			 submenu.mvaddstr(11, 18, "#{clearline}")
			 submenu.move(11,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					phone = newvalue
					dbquery = dbc.execute("UPDATE users SET phone = '#{phone}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when '0'[0] # Gender
			 clearline = " " * 1
			 submenu.mvaddstr(12, 18, "#{clearline}")
			 submenu.move(12,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					gender = newvalue
					dbquery = dbc.execute("UPDATE users SET gender = '#{gender}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when 'Y'[0], 'y'[0] # Birthday
			 clearline = " " * 10
			 submenu.mvaddstr(13, 18, "#{clearline}")
			 submenu.move(13,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
				# TODO: Do some dummy checks to ensure value meets DBMS specs
					bday = newvalue
					dbquery = dbc.execute("UPDATE users SET bday = '#{bday}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when 'I'[0], 'i'[0] # Password Expiration
			 clearline = " " * 10
			 submenu.mvaddstr(12, 60, "#{clearline}")
			 submenu.move(12,60)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
				# TODO: Do some dummy checks to ensure value meets DBMS specs
					pwexpires = newvalue
					dbquery = dbc.execute("UPDATE users SET pwexpires = '#{pwexpires}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end


		when 'h'[0], 'H'[0] # User's Password Hint
			 clearline = " " * 58
			 submenu.mvaddstr(16, 18, "#{clearline}")
			 submenu.move(16,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					pwhint = newvalue
					dbquery = dbc.execute("UPDATE users SET pwhint = '#{pwhint}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when 'n'[0], 'N'[0] # Sysop's Note
			 clearline = " " * 58
			 submenu.mvaddstr(17, 18, "#{clearline}")
			 submenu.move(17,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					sysopnote = newvalue
					dbquery = dbc.execute("UPDATE users SET sysopnote = '#{sysopnote}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when 'f'[0], 'F'[0] # Reset failed logins to 0
			self.clearfails(curuid)

		when 'l'[0], 'L'[0] # Toggle account locked
			if islocked == true
				islocked = false
			else
				islocked = true
			end 
			dbquery = dbc.execute("UPDATE users SET islocked = #{islocked} WHERE uid = '#{curuid}'")
			dbquery.finish


		when 't'[0], 'T'[0] # Time Bank System value
			 clearline = " " * 3
			 submenu.mvaddstr(14, 60, "#{clearline}")
			 submenu.move(14,60)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					timebank = newvalue.to_i
					if timebank >= -1 && timebank < 1000
 						dbquery = dbc.execute("UPDATE users SET timebank = #{timebank} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when '$'[0] # Credit System value
			 clearline = " " * 3
			 submenu.mvaddstr(13, 60, "#{clearline}")
			 submenu.move(13,60)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					credits = newvalue.to_i
					if credits >= -1 && credits < 1000
						dbquery = dbc.execute("UPDATE users SET credits = #{credits} WHERE uid = '#{curuid}'")
						dbquery.finish
					end # end if
				end # end unless

		when 'e'[0], 'E'[0] # Email
			 clearline = " " * 40
			 submenu.mvaddstr(14, 18, "#{clearline}")
			 submenu.move(14,18)
	  		 submenu.getstr(newvalue)
				unless newvalue.empty?
					email = newvalue
					dbquery = dbc.execute("UPDATE users SET email = '#{email}' WHERE uid = '#{curuid}'")
					dbquery.finish
				end

		when 'G'[0], 'g'[0] # Group
				# TODO: Populate permissions table for uid based on gid defaults when changing
			  newgroup = Group.new
			  newgid = newgroup.select(gid)
				dbquery = dbc.execute("UPDATE users SET gid = '#{newgid}' WHERE uid = '#{curuid}'")
				dbquery.finish
				permprog.changeperms(curuid, newgid)

		when 'P'[0], 'p'[0] # Edit perms for cur user
				permprog.edituserperms(curuid, login, memberof)

		when 'R'[0], 'r'[0] # Change Password
				chgpwd = Password.new
				chgpwd.adminreset(curuid)

		end # end case	
	end # end while
	dbc.disconnect
	submenu.delwin

	end


# Logged in user self edit
def edit
end # end def: edit


#
# USER EDIT FUNCTIONS BELOW
#
#

def askfirstname
	inputloop = 1
	while inputloop > 0 
	ansiputs("Enter First Name: ", blue)
		firstname = ansigets(20)
		unless firstname.match(/\W+/)	
			if firstname.length > 3
				inputloop = 0
			else
				ansiputs("\nFirst Name must be longer than 3 characters.\n", yellow)
			end # end if
		else
			ansiputs("\nInput Error: please enter only alphanumeric characters.\n", yellow)
		end # end unless
	end #end while
firstname
end #end def askfirstname


def asklastname
	inputloop = 1
	while inputloop > 0 
	ansiputs("Enter Last  Name: ", blue)
		lastname = ansigets(20) 
		unless lastname.match(/\W+/)		
			if lastname.length > 3
				inputloop = 0
			else
				ansiputs("\nFirst Name must be longer than 3 characters.\n", yellow)
			end # end if
		else
			ansiputs("\nInput Error: please enter only alphanumeric characters.\n", yellow)
		end # end unless
	end #end while
lastname
end #end def asklastname

def askstreet
	inputloop = 1
	while inputloop > 0 
	ansiputs("Enter Street Addr: ", blue)
		street = ansigets(35)
		#unless city.match(/\W+/)		
			if street.length > 3
				inputloop = 0
			else
				ansiputs("\nStreet Address must be longer than 3 characters.\n", yellow)
			end # end if
#		else
#			ansiputs("\nInput Error: please enter only alphanumeric characters.\n", yellow)
#		end # end unless
	end #end while
street
end #def askstreet

def askcity
	inputloop = 1
	while inputloop > 0 
	ansiputs("Enter your City : ", blue)
		city = ansigets(20)
#		unless city.match(/\W+/)		
			if city.length > 3
				inputloop = 0
			else
				ansiputs("\nCity must be longer than 3 characters.\n", yellow)
			end # end if
#		else
#			ansiputs("\nInput Error: please enter only alphanumeric characters.\n", yellow)
#		end # end unless
	end #end while
city
end #def askcity


def askstate
	inputloop = 1
	while inputloop > 0 
	ansiputs("State/Province  : ", blue)
		state = ansigets(3)
		unless state.match(/\W+/)
			if state.length > 1 && state.length < 4
				inputloop = 0
			else
				ansiputs("\nAbbreviation must be 1-3 character in lengths.\n", yellow)
			end # end if
		else
			ansiputs("\neInput Error: please enter only alphanumeric characters.\n", yellow)
		end # end unless
	end #end while
state
end #end def ask state


def askcountry
	inputloop = 1
	while inputloop > 0 
	ansiputs("Country Code    : ", blue)
		country = ansigets(3)
		unless country.match(/\W+/)
			if country.length > 1 && country.length < 4
				inputloop = 0
			else
				ansiputs("\nAbbreviation must be 1-3 character in length.\n", yellow)
			end # end if
		else
			ansiputs("\nInput Error: please enter only alphanumeric characters.\n", yellow)
		end # end unless
	end #end while
country
end #end def askcountry

def askpostal
	inputloop = 1
	while inputloop > 0 
	ansiputs("Postal Code     : ", blue)
		postal = ansigets(15)
		unless postal.match(/\s+/)
			if postal.length > 1 && postal.length < 15
				inputloop = 0
			else
				ansiputs("\nPostal Code must be 2-15 characters.\n", yellow)
			end # end if
		else
			ansiputs("\nInput Error: please enter only alphanumeric characters.\n", yellow)
		end # end unless
	end #end while
postal
end #end def askpostal


def askemail
#TODO: Check for unique email address
	inputloop = 1
	while inputloop > 0 
	ansiputs("Email Address   : ", blue)
		email = ansigets(35)
		if email.length > 7
			inputloop = 0
		else
			ansiputs("\nEmail Address must be longer than 7 characters\n", yellow)
		end # end if
	end #end while
email
end #end def askemail

def asklogin

dbc = DBI.connect("DBI:#{@cfgin.db_driver}:#{@cfgin.db_name}:#{@cfgin.db_host}",
						   "#{@cfgin.db_user}", "#{@cfgin.db_pass}")

	inputloop = 1
	while inputloop > 0 
	ansiputs("Login Name/Alias: ", blue)
		login = ansigets(15).downcase

# TODO: Check for spaces and illegal characters
		unless login.match(/\W+/)
			if login.length > 3
				dbquery = dbc.select_one("SELECT login FROM users WHERE login='#{login}'")
				if dbquery.nil?
					inputloop = 0	
				else
					ansiputs("\nSorry! This login name is already in use. Please select a different alias.\n", yellow)
				end # end if
			else
					ansiputs("\nSorry! Login names must be at least 4 characters long.\n", yellow)
			end #end if
		else
			ansiputs("\nLogin names must not contain non-alphanumeric character nor spaces.\n",yellow)
		end # end unless
	end # end while
login
end #end def asklogin


def askpassword
	setpw = Password.new

	ansiputs("
Password Tips: Although passwords are encrypted in the BBS database,
  you should choose a strong password to prevent your account from
  being accessed by intruders or unauthorized individuals. Choose a
  password that is at least 6 characters long, contains at least one
  number, and one uppercase letter. Symbols are also accepted.\n\n", white)

	matchloop = 1 # Loop until password and confirm inputs match
	while matchloop > 0
		inputloop = 1
		while inputloop > 0 
	#		ansiputs("Password: ", blue)
				password1 = setpw.pwprompt
				if password1.length >= 6
					inputloop = 0
				else
					ansiputs("\nPasswords must be a minimum of 6 characters.\n", yellow)
				end # end if
		end #end while inputloop

	#		ansiputs(" Confirm: ", blue)
			password2 = setpw.pwprompt
			if password1 == password2
				matchloop = 0
			else
				ansiputs("\nPasswords did not match.\n", red)
			end

	end # end matchloop
password1
end # end def askpassword

def askpwhint
	inputloop = 1
	while inputloop > 0 
	ansiputs("Enter a hint to help you remember your password.\n", yellow)
	ansiputs("Password Hint   : ", blue)
		pwhint = ansigets(30)
		if pwhint.length > 1
			inputloop = 0
		else
			ansiputs("\nPassword Hint cannot be empty\n", yellow)
		end # end if
	end #end while
pwhint
end #end def pwhint


def askbdaymonth
	inputloop = 1
	while inputloop > 0 
	ansiputs("Birthdate Month : ", blue)
		bdaymonth = ansigets(2)
		unless bdaymonth.match(/\D+/)
			if bdaymonth.length > 0
				# Check for number 1 - 12
				if	bdaymonth.to_i < 1 || bdaymonth.to_i > 12
					ansiputs("\nMonth must be between 01 - 12\n", yellow)
				else
					inputloop = 0
				end # end if
			else
				ansiputs("\nMonth cannot be empty. \n", yellow)
			end # end if
		else
			ansiputs("\nMonth value must be a digit (01, 02 ... 12)  \n", yellow)
		end # end unless
	end #end while
bdaymonth
end #end def askbdaymonth

def askbdayday
	inputloop = 1
	while inputloop > 0 
	ansiputs("Birthdate Day   : ", blue)
		bdayday = ansigets(2)
		unless bdayday.match(/\D+/)
			if bdayday.length > 0
				# Check for number 1 - 12
				if	bdayday.to_i < 1 || bdayday.to_i > 31
					ansiputs("\nDay must be between 01 - 31\n", yellow)
				else
					inputloop = 0
				end # end if
			else
				ansiputs("\nDay cannot be empty. \n", yellow)
			end # end if
		else
			ansiputs("\nDay value must be a digit (01, 02 ... 12)  \n", yellow)
		end # end unless
	end #end while
bdayday
end #end def askbdayday


def askbdayyear
	maxyear = Time.now.year - 5
	minyear = Time.now.year - 80
	inputloop = 1
	while inputloop > 0 
	ansiputs("Birthdate Year  : ", blue)
		bdayyear = ansigets(4)
		unless bdayyear.match(/\D+/)
			if bdayyear.length == 4
				# Check for number 1 - 12
				if	bdayyear.to_i > minyear && bdayyear.to_i < maxyear
					inputloop = 0				
				else
					ansiputs("\nInvalid year.\n", yellow)
				end # end if
			else
				ansiputs("\nYear must be 4 digits. \n", yellow)
			end # end if
		else
			ansiputs("\nYear value must be only digits.\n", yellow)
		end # end unless
	end #end while
bdayyear
end #end def askbdayday


def askgender
	inputloop = 1
	while inputloop > 0 
	ansiputs("Gender (M/F)    : ", blue)
		gender = ansigets(1) 
		unless gender.match(/\W+/)		
			if gender.length == 1
				if gender.upcase == "M" || gender.upcase == "F"
					inputloop = 0
				else
					ansiputs("\nInvalid Entry\n", yellow)
				end
			else
				ansiputs("\nInvalid Entry\n", yellow)
			end # end if
		else
			ansiputs("\nInput Error: please enter only M or F\n", yellow)
		end # end unless
	end #end while
gender
end #end def askgender



end
# end class: User