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

 Source File: tgincludes.rb
     Version: 0.02
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Master Includes File

---[ Changelog ]-------------------------------------------------------------


---[ TODO Items ]------------------------------------------------------------
 

=end
#
# ---[ Program Code Begins ]-------------------------------------------------

## Location of libraries 
#$:.push '/usr/local/opentg'


## Require ruby default libs
require 'fileutils'	# Used to work with read/write of files
require 'tmpdir'	# Identifies OS's temp directory
require 'yaml'		# Config file format uses YAML standard
require 'optparse'	# Options Parser (better getopts)
require 'logger'	# Logging Facility
require 'digest'	# Digest for Passwords
require 'scanf.rb'	# Alternate Input


## Require add-on gems (keep this separate for tracking & documentation)
require 'rubygems'			# Third party items
require 'highline'			# Highline Libray for Ansi & I/O
require 'highline/import'	# Highline Import Functions
require 'ncurses'				# Ncurses Library
require 'dbi'					# Database Abstraction
require 'bcrypt'				# Bcrypt for Passwords
require 'term/ansicolor' 	# ANSI Colored Terminal GEM


## Require TG libs
require 'tgrubyext.rb'		# Extensions for Ruby libs
require 'tgoutput.rb'		# Input/Output functions
require 'tgversion.rb'		# Version Data
require 'tgconfig.rb'		# Configuration Handling
require 'tgusers.rb'			# User Functions
require 'tgpermissions.rb'	# RBAC Permissions Functions
require 'tggroups.rb'		# Group Functions
require 'tgfileareas.rb'	# File Areas
require 'tgfiles.rb'			# File functions
require 'tgfileindexer.rb'	# File Indexing Functions
require 'tglogin.rb'			# Login Functions
require 'tgwho.rb'			# Who's online and History


## Includes
include Term::ANSIColor	 	# Adds Ansi Coloring to String class
