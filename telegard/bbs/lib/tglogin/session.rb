=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/tglogin.rb
     Version: 1.00
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Handlers for Login/Logout

-----------------------------------------------------------------------------
=end

=begin rdoc
= Tglogin (Login/Logout Routines)
Tglogin handles the procedures for logging into Telegard.
== Configuration Variables (see opentg.conf) $cfg['login']
login:
  attempts: 3
  lockout: 5
  usehint: true

attempts:integer - number of failed attempts to allow before disconnecting.
lockout: integer - number of failed attempts for a single user before setting account to is_locked = true.
usehint: boolean - whether to prompt user for password hint on last attempt before lockout.
allownew:boolean - will the login routine accept new users?

=end

require 'lib/tglogin/signup'
require 'lib/tglogin/session'

