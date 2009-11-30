# ncpaging02.rb <chris.tusa@opentg.org>
# Example of building a dynamically paging ncurses popup menu
#  Uses the the arrow keys to select the entry
#
require 'rubygems'
require 'dbi'
require 'ncurses'

#begin

dbc = DBI.connect("DBI:Pg:opentg:localhost", "opentg_user", "secret")
aindex = dbc.select_all "SELECT areaid, name FROM fileareas ORDER BY areaid"
totalareas = aindex.length


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
#Ncurses.nonl             # turn off newline translation



page = 1
cur = 0
count = 0
showmax = 5

numpages = totalareas.to_f / showmax
numpages = numpages.ceil


clearline = " " * 48
page = 1
cur = 0
count = 0
showmax = 5
curselect = 0

selectloop = 1

 	   popup = Ncurses.newwin(10,50,0,0)
 	   Ncurses.keypad(popup, true)
		popup.clear
		popup.attron(Ncurses.COLOR_PAIR(1))
		popup.box(0,0)

 while selectloop > 0	
	while page <= numpages
		ncrow = 2 
		popup.attron(Ncurses::A_BOLD)
		popup.mvaddstr(0, 5, "[ Selection page #{page} / #{numpages}]")
		popup.attroff(Ncurses.COLOR_PAIR(1))

		# Print menu items num per page from count -> showmax ( 1 - 5 )
		until count >= showmax
			unless aindex[cur].nil?
				item = aindex[cur][1]
				# Highlight the currently selected item, based on array value cur
				if curselect == cur
					popup.attron(Ncurses.COLOR_PAIR(2))
					popup.mvaddstr(ncrow, 2, "#{item}")
					popup.attroff(Ncurses.COLOR_PAIR(2))
				else
					popup.attron(Ncurses.COLOR_PAIR(3))
					popup.mvaddstr(ncrow, 2, "#{item}")
				end

 			   	ncrow = ncrow + 1 
					cur = cur + 1
					count = count + 1

			end # end unless

					popup.refresh

		end #end until


		case(popup.getch())

			when 'x'[0], 'X'[0]
				selectloop = 0
			 	exit 0

		   when Ncurses::KEY_DOWN
				if curselect < aindex.last[0].to_i
	  		   	curselect = curselect + 1
				else
					curselect = 0
				end
					count = 0
					cur = 0

			when Ncurses::KEY_UP
				if curselect > 0
			   	curselect = curselect - 1
				else
					curselect = aindex.last[0].to_i
				end
					count = 0
					cur = 0

					
=begin
			when ']'[0]
			if page < numpages
				page = page + 1
				count = 0
			else 
				page = 1
				cur = 0
				count = 0
			end

			when '['[0]
				if page == 1
					page = numpages
					count = 0
				else 
					page = page - 1
					cur = 0
					count = 0
				end
=end

		end # END CASE
		end # END WHILE "count < showmax"
end # END WHILE "selectloop"

#ensure
popup.delwin
Ncurses.endwin
#end
