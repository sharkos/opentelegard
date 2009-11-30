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

 Source File: tgrubyext.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Ruby Extensions to existing classes


---[ Changelog ]-------------------------------------------------------------



---[ Todo Items ]------------------------------------------------------------



=end
#
# ---[ Program Code Begins ]-------------------------------------------------

#
# Extends fixunum class for some date/time foo
#
class Fixnum
	def seconds
		self
	end

	def minutes
		self * 60
	end

	def hours
		self * 60 * 60
	end

	def days
		self * 60 * 60 * 24
	end
end